#import "SQLiteStore.h"

@implementation SQLiteStore

- (id)init {
    self = [super init];
    if (self) {
        _dbcon = [[SQLiteDatabaseConnection alloc]initWithDatabaseFileNamed:@"vs"];
    }
    return self;
}

- (BOOL)closeStore {
    return [_dbcon closeConnection];
}

- (void)dealloc {
    [self closeStore];
}

- (BOOL)relationExistsWithScheduleIdentifier:(NSInteger)scheduleIdentifier containingPictogramIdentifier:(NSInteger)pictogramIdentifier atIndex:(NSInteger)index {
    NSString *query = @"SELECT atIndex FROM ScheduleWithPictograms WHERE schedule = (?) AND pictogram = (?) AND atIndex = (?)";
    sqlite3_stmt *statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindIntegerToStatement:statement integer:scheduleIdentifier atPosition:1];
    [_dbcon bindIntegerToStatement:statement integer:pictogramIdentifier atPosition:2];
    [_dbcon bindIntegerToStatement:statement integer:index atPosition:3];
    BOOL exists = NO;
    if ([_dbcon rowExistsFromStatement:statement]) {
        exists = YES;
    }
    [_dbcon finalizeStatement:statement];
    return exists;
}

#pragma mark - Schedules
- (NSArray *)contentOfAllSchedules {
    NSString *query = @"SELECT id, title, color FROM schedule ORDER BY id ASC";
    NSMutableArray *results = [NSMutableArray array];
    sqlite3_stmt *statement = [_dbcon prepareStatementWithQuery:query];
    while ([_dbcon rowExistsFromStatement:statement]) {
        int uid = [_dbcon integerFromStatement:statement atColumnIndex:0];
        NSString* title = [_dbcon stringFromStatement:statement atColumnIndex:1];
        int color = [_dbcon integerFromStatement:statement atColumnIndex:2];
        [results addObject:@{@"id" : [NSNumber numberWithInt:uid],
                                @"title" : title,
                                @"color" : [NSNumber numberWithInt:color]}];
    }
    [_dbcon finalizeStatement:statement];
    return results;
}

- (NSInteger)createSchedule:(NSDictionary *)content {
    NSParameterAssert(content != nil);
    NSString *titleForSchedule = [content valueForKey:@"title"];
    NSNumber *colorForSchedule = [content valueForKey:@"color"];
    if (titleForSchedule == nil) @throw [NSException exceptionWithName:NSInvalidArgumentException
                                                                reason:@"titleForSchedule is nil." userInfo:nil];
    if (colorForSchedule == nil) @throw [NSException exceptionWithName:NSInvalidArgumentException
                                                                reason:@"colorForSchedule is nil." userInfo:nil];
    NSString *query = @"INSERT INTO schedule (title, color) VALUES (?,?)";
    sqlite3_stmt *statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindTextToStatement:statement text:titleForSchedule atPosition:1];
    [_dbcon bindIntegerToStatement:statement integer:colorForSchedule.integerValue atPosition:2];
    [_dbcon stepStatement:statement];
    [_dbcon finalizeStatement:statement];
    return [_dbcon lastInsertRowID];
}

- (void)deleteScheduleWithID:(NSInteger)identifier {
    NSParameterAssert(identifier >= 0);
    NSString *query = @"DELETE FROM schedule WHERE id IS (?)";
    sqlite3_stmt *statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindIntegerToStatement:statement integer:identifier atPosition:1];
    [_dbcon stepStatement:statement];
    [_dbcon finalizeStatement:statement];
}

- (BOOL)scheduleExistsWithIdentifier:(NSInteger)scheduleIdentifier {
    NSString *query = @"SELECT id FROM schedule WHERE id = (?)";
    sqlite3_stmt *statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindIntegerToStatement:statement integer:scheduleIdentifier atPosition:1];
    BOOL exists = NO;
    if ([_dbcon rowExistsFromStatement:statement]) {
        exists = YES;
    }
    [_dbcon finalizeStatement:statement];
    return exists;
}

#pragma mark - Pictograms
- (NSArray *)contentOfAllPictogramsIncludingImageData:(BOOL)value {
    NSMutableArray *results = [NSMutableArray array];
    NSString *query;
    if(value == YES){
        query = @"SELECT id, title, image FROM pictogram ORDER BY title ASC";
    }else{
        query = @"SELECT id, title FROM pictogram ORDER BY title ASC";
    }
    sqlite3_stmt *statement = [_dbcon prepareStatementWithQuery:query];
    while ([_dbcon rowExistsFromStatement:statement]) {
        int uid = [_dbcon integerFromStatement:statement atColumnIndex:0];
        NSString *title = [_dbcon stringFromStatement:statement atColumnIndex:1];
        if (value) {
            NSData* imageData = [_dbcon dataFromStatement:statement atColumnIndex:2];
            [results addObject:@{@"id" : [NSNumber numberWithInt:uid],
                                 @"title" : title,
                                 @"image" : imageData}];
        } else {
            [results addObject:@{@"id" : [NSNumber numberWithInt:uid],
                                 @"title" : title}];
        }
    }
    [_dbcon finalizeStatement:statement];
    return results;
}

- (NSInteger)createPictogram:(NSDictionary *)content {
    NSParameterAssert(content != nil);
    NSString *titleForPictogram = [content valueForKey:@"title"];
    NSData *imageDataForPictogram = [content valueForKey:@"image"];
    if (titleForPictogram == nil) @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"titleForPictogram is nil." userInfo:nil];
    if (imageDataForPictogram == nil) @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"imageDataForPictogram is nil." userInfo:nil];
    NSString *query = @"INSERT INTO pictogram (title, image) VALUES (?,?)";
    sqlite3_stmt *statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindTextToStatement:statement text:titleForPictogram atPosition:1];
    [_dbcon bindObjectDataBlobToStatement:statement anObject:imageDataForPictogram atPosition:2];
    [_dbcon stepStatement:statement];
    [_dbcon finalizeStatement:statement];
    return [_dbcon lastInsertRowID];
}

- (BOOL)deletePictogramWithID:(NSInteger)identifier {
    NSParameterAssert(identifier >= 0);
    if ([self isPictogramUsedByASchedule:identifier]) return NO;
    if ([self pictogramExistsWithIdentifier:identifier] == NO) {
        @throw [NSException exceptionWithName:@"Deletion failiure." reason:@"Trying to delete a nonexisting pictogram." userInfo:nil];
    }
    NSString *query = @"DELETE FROM pictogram WHERE id IS (?)";
    sqlite3_stmt *statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindIntegerToStatement:statement integer:identifier atPosition:1];
    [_dbcon stepStatement:statement];
    [_dbcon finalizeStatement:statement];
    return YES;
}

- (BOOL)isPictogramUsedByASchedule:(NSInteger)pictogramIdentifier {
    NSParameterAssert(pictogramIdentifier >= 0);
    BOOL isUsed = NO;
    
    NSString *query = @"SELECT pictogram FROM ScheduleWithPictograms WHERE pictogram = (?)";
    sqlite3_stmt *statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindIntegerToStatement:statement integer:pictogramIdentifier atPosition:1];
    if ([_dbcon rowExistsFromStatement:statement]) {
        isUsed = YES;
    }
    [_dbcon finalizeStatement:statement];
    return isUsed;
}

- (BOOL)pictogramExistsWithIdentifier:(NSInteger)pictogramIdentifier {
    BOOL exists = NO;
    NSString *query = @"SELECT id FROM pictogram WHERE id = (?)";
    sqlite3_stmt *statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindIntegerToStatement:statement integer:pictogramIdentifier atPosition:1];
    if ([_dbcon rowExistsFromStatement:statement]) {
        exists = YES;
    }
    [_dbcon finalizeStatement:statement];
    return exists;
}

- (NSArray *)contentOfAllPictogramsInSchedule:(NSInteger)identifier includingImageData:(BOOL)value {
    NSParameterAssert([self scheduleExistsWithIdentifier:identifier]);
    NSMutableArray *results = [NSMutableArray array];
    NSString* query;
    if(value == YES){
        query = @"SELECT P.id, P.title, P.image FROM pictogram AS P JOIN ScheduleWithPictograms AS SP ON P.id = SP.pictogram WHERE SP.schedule = (?) ORDER BY SP.atIndex";
    }else{
        query = @"SELECT P.id, P.title FROM pictogram AS P JOIN ScheduleWithPictograms AS SP ON P.id = SP.pictogram WHERE SP.schedule = (?) ORDER BY SP.atIndex";
    }
    sqlite3_stmt *statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindIntegerToStatement:statement integer:identifier atPosition:1];
    while ([_dbcon rowExistsFromStatement:statement]) {
        int uid = [_dbcon integerFromStatement:statement atColumnIndex:0];
        NSString *title = [_dbcon stringFromStatement:statement atColumnIndex:1];
        if(value == YES){
            NSData *imageData = [_dbcon dataFromStatement:statement atColumnIndex:2];
            [results addObject:@{@"id" : [NSNumber numberWithInt:uid],
                                 @"title" : title,
                                 @"image" : imageData}];
        }else{
            [results addObject:@{@"id": [NSNumber numberWithInt:uid],
                                 @"title": title}];
        }
    }
    [_dbcon finalizeStatement:statement];
    return results;
}

#pragma mark - Relation

- (void)addPictogram:(NSInteger)pictogramIdentifier toSchedule:(NSInteger)scheduleIdentifier atIndex:(NSInteger)index {
    NSLog(@"adding pictogram");
    NSParameterAssert([self pictogramExistsWithIdentifier:pictogramIdentifier]);
    NSParameterAssert([self scheduleExistsWithIdentifier:scheduleIdentifier]);
    NSString *query = @"INSERT INTO ScheduleWithPictograms (schedule, pictogram, atIndex) VALUES (?,?,?)";
    sqlite3_stmt *statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindIntegerToStatement:statement integer:scheduleIdentifier atPosition:1];
    [_dbcon bindIntegerToStatement:statement integer:pictogramIdentifier atPosition:2];
    [_dbcon bindIntegerToStatement:statement integer:index atPosition:3];
    [_dbcon stepStatement:statement];
    [_dbcon finalizeStatement:statement];
}

- (void)removePictogram:(NSInteger)pictogramIdentifier fromSchedule:(NSInteger)scheduleIdentifier atIndex:(NSInteger)index {
    NSLog(@"Reemoving pictogram");
    if ([self relationExistsWithScheduleIdentifier:scheduleIdentifier containingPictogramIdentifier:pictogramIdentifier atIndex:index] != YES) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Trying to delete a relation which does not excist in the database." userInfo:nil];
    }
    NSString *query = @"DELETE FROM ScheduleWithPictograms WHERE schedule = (?) AND pictogram = (?) AND atIndex = (?)";
    sqlite3_stmt *statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindIntegerToStatement:statement integer:scheduleIdentifier atPosition:1];
    [_dbcon bindIntegerToStatement:statement integer:pictogramIdentifier atPosition:2];
    [_dbcon bindIntegerToStatement:statement integer:index atPosition:3];
    [_dbcon stepStatement:statement];
    [_dbcon finalizeStatement:statement];
}
@end