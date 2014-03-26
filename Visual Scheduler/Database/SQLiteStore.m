#import "SQLiteStore.h"

@implementation SQLiteStore

- (id)init {
    self = [super init];
    if (self) {
        [self establishDatabaseConnection];
    }
    return self;
}

#pragma mark - Database Connection

- (void)establishDatabaseConnection {
    NSString *sqlite3File = [[NSBundle mainBundle] pathForResource:@"vs" ofType:@"sqlite3"];
    if (sqlite3_open([sqlite3File UTF8String], &_databaseConnection) != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"Could not establish connection to database." reason:@"Unknown" userInfo:nil];
    }
    if (sqlite3File == nil) {
        @throw [NSException exceptionWithName:@"SQLite3 database was not found." reason:@"Unknown" userInfo:nil];
    }
}

- (BOOL)closeStore {
    return sqlite3_close(_databaseConnection) == SQLITE_OK ? YES : NO;
}

- (sqlite3_stmt *)prepareStatementWithQuery:(NSString *)query {
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_databaseConnection, [query UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"DB Error: Failed to prepare statement." reason:query userInfo:nil];
    }
    return statement;
}

#pragma mark - Schedules

- (NSArray *)contentOfAllSchedules {
    NSString *query = @"SELECT id, title, color FROM schedule ORDER BY title ASC";
    NSMutableArray *results = [NSMutableArray array];
    sqlite3_stmt *statement = [self prepareStatementWithQuery:query];
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        int uid = sqlite3_column_int(statement, 0);
        char *title = (char *)sqlite3_column_text(statement, 1);
        int color = sqlite3_column_int(statement, 2);
        [results addObject:@{@"id" : [NSNumber numberWithInt:uid],
                                @"title" : [NSString stringWithCString:title encoding:NSUTF8StringEncoding],
                                @"color" : [NSNumber numberWithInt:color]}];
    }
    sqlite3_finalize(statement);

    return results;
}

- (NSInteger)createSchedule:(NSDictionary *)content {
    NSParameterAssert(content != nil);
    
    NSString *titleForSchedule = [content valueForKey:@"title"];
    NSNumber *colorForSchedule = [content valueForKey:@"color"];
    
    if (titleForSchedule == nil) @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"titleForSchedule is nil." userInfo:nil];
    if (colorForSchedule == nil) @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"colorForSchedule is nil." userInfo:nil];
    
    NSString *query = @"INSERT INTO schedule (title, color) VALUES (?,?)";
    sqlite3_stmt *statement = [self prepareStatementWithQuery:query];

    if (sqlite3_bind_text(statement, 1, [titleForSchedule UTF8String], -1, SQLITE_TRANSIENT) != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"SQLite3 database." reason:@"Unknown" userInfo:nil];
    }
    if (sqlite3_bind_int64(statement, 2, colorForSchedule.integerValue) != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"SQLite3 database." reason:@"Unknown" userInfo:nil];
    }
    if (sqlite3_step(statement) != SQLITE_DONE) {
        @throw [NSException exceptionWithName:@"SQLite3 database." reason:@"Unknown" userInfo:nil];
    }
    sqlite3_finalize(statement);
    return sqlite3_last_insert_rowid(_databaseConnection);
}

- (void)deleteScheduleWithID:(NSInteger)identifier {
    NSParameterAssert(identifier >= 0);
    
    NSString *query = @"DELETE FROM schedule WHERE id IS (?)";
    sqlite3_stmt *statement = [self prepareStatementWithQuery:query];
    
    if (sqlite3_bind_int64(statement, 1, identifier) != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"SQLite3 failed to mark record for deletion." reason:@"Unknown" userInfo:nil];
    }
    if (sqlite3_step(statement) != SQLITE_DONE) {
        @throw [NSException exceptionWithName:@"SQLite3 failed to delete record." reason:@"Unknown" userInfo:nil];
    }
    sqlite3_finalize(statement);
}

#pragma mark - Pictograms

- (NSArray *)contentOfAllPictograms {
    NSMutableArray *results = [NSMutableArray array];
    
    NSString *query = @"SELECT id, title, image FROM pictogram ORDER BY title ASC";
    sqlite3_stmt *statement = [self prepareStatementWithQuery:query];
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        int uid = sqlite3_column_int(statement, 0);
        char *title = (char *)sqlite3_column_text(statement, 1);
        
        const void *ptrToImageData = sqlite3_column_blob(statement, 2);
        int imageDataSize = sqlite3_column_bytes(statement, 2);
        NSData *imageData = [[NSData alloc] initWithBytes:ptrToImageData length:imageDataSize];
        
        [results addObject:@{@"id" : [NSNumber numberWithInt:uid],
                                @"title" : [NSString stringWithCString:title encoding:NSUTF8StringEncoding],
                                @"image" : imageData}];
    }
    sqlite3_finalize(statement);

    return results;
}

- (NSInteger)createPictogram:(NSDictionary *)content {
    NSParameterAssert(content != nil);
    
    NSString *titleForPictogram = [content valueForKey:@"title"];
    NSData *imageDataForPictogram = [content valueForKey:@"image"];
    
    if (titleForPictogram == nil) @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"titleForPictogram is nil." userInfo:nil];
    if (imageDataForPictogram == nil) @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"imageDataForPictogram is nil." userInfo:nil];
    
    NSString *query = @"INSERT INTO pictogram (title, image) VALUES (?,?)";
    sqlite3_stmt *statement = [self prepareStatementWithQuery:query];
    
    if (sqlite3_bind_text(statement, 1, [titleForPictogram UTF8String], -1, SQLITE_TRANSIENT) != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"SQLite3 database." reason:@"Unknown" userInfo:nil];
    }
    if (sqlite3_bind_blob(statement, 2, [imageDataForPictogram bytes], (int)imageDataForPictogram.length, NULL) != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"SQLite3 database." reason:@"Unknown" userInfo:nil];
    }
    if (sqlite3_step(statement) != SQLITE_DONE) {
        @throw [NSException exceptionWithName:@"SQLite3 database." reason:@"Unknown" userInfo:nil];
    }
    sqlite3_finalize(statement);
    return sqlite3_last_insert_rowid(_databaseConnection);
}


@end