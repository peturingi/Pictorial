#define ESTABLISH_DATABASE_CONNECTION_FAILED_EXCEPTION @"SMEstablishDatabaseConnection"
#define LOCATE_SETTINGS_FILE_FAILED_EXCEPTION @"SMLocateSettingsFileFailed"
#define PREPARE_STATEMENT_WITH_QUERY_FAILED_EXCEPTION @"SMPrepareStatementWithQueryFailed"
#define BIND_TO_STATEMENT_FAILED_EXCEPTION @"SMBindToStatementFailed"
#define STATEMENT_STEP_FAILED_EXCEPTION @"SMStatementStepFailed"



#import "SQLiteDatabaseConnection.h"

@implementation SQLiteDatabaseConnection

-(id)initWithDatabaseFileNamed:(NSString *)filename{
    self = [super init];
    if(self){
        [self validateString:filename];
        [self establishDatabaseConnectionWithFileNamed:filename];
    }
    return self;
}

- (void)establishDatabaseConnectionWithFileNamed:(NSString*)filename{
    NSString *databaseFilename = [self locateSettingsFile:filename];
    int result = sqlite3_open([databaseFilename UTF8String], &_connection);
    if (result != SQLITE_OK) {
        @throw [NSException exceptionWithName:ESTABLISH_DATABASE_CONNECTION_FAILED_EXCEPTION reason:@"Could not open databasefile" userInfo:nil];
    }
}

-(NSString*)locateSettingsFile:(NSString*)filename{
    NSString *settingsFile = [[NSBundle mainBundle] pathForResource:filename ofType:@"sqlite3"];
    if (settingsFile == nil) {
        @throw [NSException exceptionWithName:LOCATE_SETTINGS_FILE_FAILED_EXCEPTION reason:@"Could not locate settings file, or the file is corrupt. The required file is settings.sqlite3, and should be available in mainbundle" userInfo:nil];
    }
    return settingsFile;
}

-(sqlite3_stmt*)prepareStatementWithQuery:(NSString *)query {
    sqlite3_stmt *statement;
    [self validateString:query];
    if (sqlite3_prepare_v2(_connection, [query UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        @throw [NSException exceptionWithName:PREPARE_STATEMENT_WITH_QUERY_FAILED_EXCEPTION reason:@"Failed to prepare statement with query. Query is probably invalid." userInfo:nil];
    }
    return statement;
}

-(void)finalizeStatement:(sqlite3_stmt*)statement{
    [self validateStatement:statement];
    sqlite3_finalize(statement);
}

-(void)stepStatement:(sqlite3_stmt*)statement{
    [self validateStatement:statement];
    if (sqlite3_step(statement) != SQLITE_DONE) {
        @throw [NSException exceptionWithName:STATEMENT_STEP_FAILED_EXCEPTION reason:@"Failed to process statement" userInfo:nil];
    }
}

-(void)bindIntegerToStatement:(sqlite3_stmt*)statement integer:(NSInteger)value atPosition:(NSInteger)position{
    [self validateStatement:statement];
    [self validateBindPosition:position];
    if (sqlite3_bind_int64(statement, position, value) != SQLITE_OK) {
        @throw [NSException exceptionWithName:BIND_TO_STATEMENT_FAILED_EXCEPTION reason:@"Failed to bind integer to statement" userInfo:nil];
    }
}

-(void)bindTextToStatement:(sqlite3_stmt*)statement text:(NSString*)value atPosition:(NSInteger)position{
    [self validateStatement:statement];
    [self validateString:value];
    [self validateBindPosition:position];
    if (sqlite3_bind_text(statement, position, [value UTF8String], -1, SQLITE_TRANSIENT) != SQLITE_OK) {
        @throw [NSException exceptionWithName:BIND_TO_STATEMENT_FAILED_EXCEPTION reason:@"Failed to bind text to statement" userInfo:nil];
    }
}

-(void)bindObjectDataBlobToStatement:(sqlite3_stmt*)statement anObject:(id)object atPosition:(NSInteger)position{
    [self validateStatement:statement];
    [self validateBindPosition:position];
    if(object == nil){
        @throw [NSException exceptionWithName:@"NilObjectException" reason:@"Object was nil" userInfo:nil];
    }
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:object];
    if (sqlite3_bind_blob(statement, position, [data bytes], (int)data.length, NULL) != SQLITE_OK) {
        @throw [NSException exceptionWithName:BIND_TO_STATEMENT_FAILED_EXCEPTION reason:@"Failed to bind datablob to statement" userInfo:nil];
    }
}

-(NSData*)dataFromStatement:(sqlite3_stmt*)statement atColumnIndex:(NSInteger)index{
    [self validateStatement:statement];
    [self validateColumnIndex:index];
    const void *ptrToData = sqlite3_column_blob(statement, index);
    int dataSize = sqlite3_column_bytes(statement, index);
    return [[NSData alloc] initWithBytes:ptrToData length:dataSize];
}

-(NSString*)stringFromStatement:(sqlite3_stmt*)statement atColumnIndex:(NSInteger)index{
    [self validateStatement:statement];
    [self validateColumnIndex:index];
    char *title = (char *)sqlite3_column_text(statement, index);
    return [NSString stringWithCString:title encoding:NSUTF8StringEncoding];
}

-(NSInteger)integerFromStatement:(sqlite3_stmt *)statement atColumnIndex:(NSInteger)index{
    [self validateStatement:statement];
    [self validateColumnIndex:index];
    return sqlite3_column_int(statement, index);
}

-(NSInteger)lastInsertRowID{
    return (NSInteger)sqlite3_last_insert_rowid(_connection);
}

-(BOOL)closeConnection{
    return sqlite3_close(_connection) == SQLITE_OK;
}

-(BOOL)rowExistsFromStatement:(sqlite3_stmt *)statement{
    return sqlite3_step(statement) == SQLITE_ROW;
}

#pragma mark - validate parameters
-(void)validateString:(NSString*)string{
    if([string length] == 0){
        @throw [NSException exceptionWithName:@"InvalidStringException" reason:@"string was either nil or empty" userInfo:nil];
    }
}

-(void)validateStatement:(sqlite3_stmt*)statement{
    if(statement == nil){
        @throw [NSException exceptionWithName:@"StatmentIsNilException" reason:@"Statement was nil" userInfo:nil];
    }
}

-(void)validateColumnIndex:(NSInteger)index{
    if(index < 0){
        @throw [NSException exceptionWithName:@"InvalidIndexException" reason:@"Index cannot be negative" userInfo:nil];
    }
}

-(void)validateBindPosition:(NSInteger)position{
    if(position < 1){
        @throw [NSException exceptionWithName:@"InvalidColumnExpection" reason:@"Columnposition cannot be 0 or negative" userInfo:nil];
    }
}
@end
