#import "SQLiteStore.h"

@implementation SQLiteStore

- (id)init {
    self = [super init];
    if (self) {
        [self establishDatabaseConnection];
    }
    return self;
}

- (void)establishDatabaseConnection {
    NSString *sqlite3File = [[NSBundle mainBundle] pathForResource:@"vs" ofType:@"sqlite3"];
    if (sqlite3_open([sqlite3File UTF8String], &_databaseConnection) != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"Could not establish connection to database." reason:@"Unknown" userInfo:nil];
    }
    if (sqlite3File == nil) {
        @throw [NSException exceptionWithName:@"SQLite3 database was not found." reason:@"Unknown" userInfo:nil];
    }
}

- (NSArray *)contentOfAllSchedules {
    NSString *query = @"SELECT id, title, color FROM schedule ORDER BY title ASC";
    NSMutableArray *results = [NSMutableArray array];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_databaseConnection, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uid = sqlite3_column_int(statement, 0);
            char *title = (char *)sqlite3_column_text(statement, 1);
            int color = sqlite3_column_int(statement, 2);
            [results addObject:@{@"id" : [NSNumber numberWithInt:uid],
                                 @"title" : [NSString stringWithCString:title encoding:NSUTF8StringEncoding],
                                 @"color" : [NSNumber numberWithInt:color]}];
        }
        sqlite3_finalize(statement);
    } else {
        @throw [NSException exceptionWithName:@"Query failed." reason:@"Unknown" userInfo:nil];
    }
    return results;
}

- (NSInteger)createSchedule:(NSDictionary *)content {
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_databaseConnection, "INSERT INTO schedule (title, color) VALUES (?,?)", -1, &statement, NULL) != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"SQLite3 database." reason:@"Unknown" userInfo:nil];
    }
    if (sqlite3_bind_text(statement, 1, [[content valueForKey:@"title"] UTF8String], -1, SQLITE_TRANSIENT) != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"SQLite3 database." reason:@"Unknown" userInfo:nil];
    }
    sqlite3_int64 color = [[content valueForKey:@"color"] integerValue];
    if (sqlite3_bind_int64(statement, 2, color) != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"SQLite3 database." reason:@"Unknown" userInfo:nil];
    }
    if (sqlite3_step(statement) != SQLITE_DONE) {
        @throw [NSException exceptionWithName:@"SQLite3 database." reason:@"Unknown" userInfo:nil];
    }
    sqlite3_finalize(statement);
    return sqlite3_last_insert_rowid(_databaseConnection);
}

- (void)deleteScheduleWithID:(NSInteger)identifier {
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_databaseConnection, "DELETE FROM schedule WHERE id IS (?)", -1, &statement, NULL) != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"SQLite3 failed to prepare for deletion." reason:@"Unknown" userInfo:nil];
    }
    if (sqlite3_bind_int64(statement, 1, identifier) != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"SQLite3 failed to mark record for deletion." reason:@"Unknown" userInfo:nil];
    }
    if (sqlite3_step(statement) != SQLITE_DONE) {
        @throw [NSException exceptionWithName:@"SQLite3 failed to delete record." reason:@"Unknown" userInfo:nil];
    }
    sqlite3_finalize(statement);
}

- (BOOL)closeStore {
    return sqlite3_close(_databaseConnection) == SQLITE_OK ? YES : NO;
}

@end
