#import "SQLiteStore.h"

#define ID_KEY @"id"
#define COLOR_KEY @"color"
#define TITLE_KEY @"title"
#define IMAGE_KEY @"image"
#define DB_FILENAME @"vs"

@implementation SQLiteStore

- (id)init {
    self = [super init];
    if (self) {
        _dbcon = [[SQLiteDatabaseConnection alloc]initWithDatabaseFileNamed:DB_FILENAME];
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
        NSMutableDictionary* content = [NSMutableDictionary dictionary];
        int uid = [_dbcon integerFromStatement:statement atColumnIndex:0];
        [content setValue:[NSNumber numberWithInt:uid] forKey:ID_KEY];
        NSString* title = [_dbcon stringFromStatement:statement atColumnIndex:1];
        [content setValue:title forKey:TITLE_KEY];
        int color = [_dbcon integerFromStatement:statement atColumnIndex:2];
        [content setValue:[NSNumber numberWithInt:color] forKey:COLOR_KEY];
        [results addObject:content];
    }
    [_dbcon finalizeStatement:statement];
    return results;
}

- (NSInteger)createSchedule:(NSDictionary *)content {
    NSParameterAssert(content != nil);
    NSString *titleForSchedule = [content valueForKey:TITLE_KEY];
    NSNumber *colorForSchedule = [content valueForKey:COLOR_KEY];
    if (titleForSchedule == nil){
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"titleForSchedule is nil." userInfo:nil];
    }
    if (colorForSchedule == nil){
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"colorForSchedule is nil." userInfo:nil];
    }
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
- (NSArray *)contentOfAllPictogramsIncludingImageData:(BOOL)includesData {
    NSString* imageString = @"";
    if(includesData){
        imageString = @", image";
    }
    NSString *query = [NSString stringWithFormat:@"SELECT id, title%@ FROM pictogram ORDER BY title ASC", imageString];
    sqlite3_stmt *statement = [_dbcon prepareStatementWithQuery:query];
    NSMutableArray *results = [NSMutableArray array];
    while ([_dbcon rowExistsFromStatement:statement]) {
        NSMutableDictionary* content = [NSMutableDictionary dictionary];
        int uid = [_dbcon integerFromStatement:statement atColumnIndex:0];
        [content setValue:[NSNumber numberWithInt:uid] forKey:@"id"];
        NSString *title = [_dbcon stringFromStatement:statement atColumnIndex:1];
        [content setValue:title forKey:@"title"];
        if (includesData) {
            NSData* imageData = [_dbcon dataFromStatement:statement atColumnIndex:2];
            [content setValue:imageData forKey:@"image"];
        }
        [results addObject:content];
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
    if ([self isPictogramUsedByASchedule:identifier]){
        return NO;
    }
    if ([self pictogramExistsWithIdentifier:identifier] == NO) {
        @throw [NSException exceptionWithName:@"Deletion failure." reason:@"Trying to delete a nonexisting pictogram." userInfo:nil];
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
    NSString *query = @"SELECT pictogram FROM ScheduleWithPictograms WHERE pictogram = (?)";
    sqlite3_stmt *statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindIntegerToStatement:statement integer:pictogramIdentifier atPosition:1];
    BOOL isUsed = NO;
    if ([_dbcon rowExistsFromStatement:statement]) {
        isUsed = YES;
    }
    [_dbcon finalizeStatement:statement];
    return isUsed;
}

- (BOOL)pictogramExistsWithIdentifier:(NSInteger)pictogramIdentifier {
    NSString *query = @"SELECT id FROM pictogram WHERE id = (?)";
    sqlite3_stmt *statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindIntegerToStatement:statement integer:pictogramIdentifier atPosition:1];
    BOOL exists = NO;
    if ([_dbcon rowExistsFromStatement:statement]) {
        exists = YES;
    }
    [_dbcon finalizeStatement:statement];
    return exists;
}

- (NSArray *)contentOfAllPictogramsInSchedule:(NSInteger)identifier includingImageData:(BOOL)includesData {
    NSParameterAssert([self scheduleExistsWithIdentifier:identifier]);
    NSString* pImage = @"";
    if(includesData){
        pImage = @", P.image";
    }
    NSString* query = [NSString stringWithFormat:@"SELECT P.id, P.title%@ FROM pictogram AS P JOIN ScheduleWithPictograms AS SP ON P.id = SP.pictogram WHERE SP.schedule = (?) ORDER BY SP.atIndex", pImage];
    sqlite3_stmt *statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindIntegerToStatement:statement integer:identifier atPosition:1];
    NSMutableArray *results = [NSMutableArray array];
    while ([_dbcon rowExistsFromStatement:statement]) {
        NSMutableDictionary* content = [NSMutableDictionary dictionary];
        int uid = [_dbcon integerFromStatement:statement atColumnIndex:0];
        [content setValue:[NSNumber numberWithInt:uid] forKey:@"id"];
        NSString *title = [_dbcon stringFromStatement:statement atColumnIndex:1];
        [content setValue:title forKey:@"title"];
        if(includesData == YES){
            NSData* imageData = [_dbcon dataFromStatement:statement atColumnIndex:2];
            [content setValue:imageData forKey:@"image"];
        }
        [results addObject:content];
    }
    [_dbcon finalizeStatement:statement];
    return results;
}

-(NSArray*)contentOfPictogramWithID:(NSInteger)identifier{
    NSParameterAssert([self pictogramExistsWithIdentifier:identifier]);
    NSMutableArray* results = [NSMutableArray array];
    NSString* query = @"SELECT image FROM pictogram WHERE id IS (?)";
    sqlite3_stmt* statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindIntegerToStatement:statement integer:identifier atPosition:1];
    while([_dbcon rowExistsFromStatement:statement]){
        NSData* imageData = [_dbcon dataFromStatement:statement atColumnIndex:0];
        [results addObject:imageData];
    }
    [_dbcon finalizeStatement:statement];
    return results;
}

#pragma mark - Relation

- (void)addPictogram:(NSInteger)pictogramIdentifier toSchedule:(NSInteger)scheduleIdentifier atIndex:(NSInteger)index {
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
    if ([self relationExistsWithScheduleIdentifier:scheduleIdentifier containingPictogramIdentifier:pictogramIdentifier atIndex:index] != YES) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Trying to delete a relation which does not exist in the database." userInfo:nil];
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