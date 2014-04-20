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
    if (sqlite3_prepare_v2(_connection, [query UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        @throw [NSException exceptionWithName:PREPARE_STATEMENT_WITH_QUERY_FAILED_EXCEPTION reason:@"Failed to prepare statement with query. Query is probably invalid." userInfo:nil];
    }
    return statement;
}

-(void)finalizeStatement:(sqlite3_stmt*)statement{
    sqlite3_finalize(statement);
}

-(void)stepStatement:(sqlite3_stmt*)statement{
    int ret = sqlite3_step(statement);// != SQLITE_DONE;
    if (ret != SQLITE_DONE) {
        @throw [NSException exceptionWithName:STATEMENT_STEP_FAILED_EXCEPTION reason:@"Failed to process statement" userInfo:nil];
    }
}

-(void)bindIntegerToStatement:(sqlite3_stmt*)statement integer:(NSInteger)value atPosition:(NSInteger)position{
    if (sqlite3_bind_int64(statement, position, value) != SQLITE_OK) {
        @throw [NSException exceptionWithName:BIND_TO_STATEMENT_FAILED_EXCEPTION reason:@"Failed to bind integer to statement" userInfo:nil];
    }
}

-(void)bindTextToStatement:(sqlite3_stmt*)statement text:(NSString*)value atPosition:(NSInteger)position{
    if (sqlite3_bind_text(statement, position, [value UTF8String], -1, SQLITE_TRANSIENT) != SQLITE_OK) {
        @throw [NSException exceptionWithName:BIND_TO_STATEMENT_FAILED_EXCEPTION reason:@"Failed to bind text to statement" userInfo:nil];
    }
}

-(void)bindObjectDataBlobToStatement:(sqlite3_stmt*)statement anObject:(id)object atPosition:(NSInteger)position{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:object];
    if (sqlite3_bind_blob(statement, position, [data bytes], (int)data.length, NULL) != SQLITE_OK) {
        @throw [NSException exceptionWithName:BIND_TO_STATEMENT_FAILED_EXCEPTION reason:@"Failed to bind datablob to statement" userInfo:nil];
    }
}

-(NSData*)dataFromStatement:(sqlite3_stmt*)statement atColumnIndex:(NSInteger)index{
    const void *ptrToData = sqlite3_column_blob(statement, index);
    int dataSize = sqlite3_column_bytes(statement, index);
    NSData *data = [[NSData alloc] initWithBytes:ptrToData length:dataSize];
    return data;
}

-(NSString*)stringFromStatement:(sqlite3_stmt*)statement atColumnIndex:(NSInteger)index{
    NSString* value;
    char *title = (char *)sqlite3_column_text(statement, index);
    value = [NSString stringWithCString:title encoding:NSUTF8StringEncoding];
    return value;
}

-(NSInteger)integerFromStatement:(sqlite3_stmt *)statement atColumnIndex:(NSInteger)index{
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
@end
