#import "SettingsManager.h"
@implementation SettingsManager
-(id)init{
    self = [super init];
    if(self){
        [self establishDatabaseConnection];
    }
    return self;
}

- (void)establishDatabaseConnection {
    NSString *sqlite3File = [self locateSettingsFile];
    if (sqlite3_open([sqlite3File UTF8String], &_databaseConnection) != SQLITE_OK) {
        @throw [NSException exceptionWithName:SM_ESTABLISH_DATABASE_CONNECTION_FAILED_EXCEPTION reason:@"Could not open databasefile" userInfo:nil];
    }
}

-(NSString*)locateSettingsFile{
    NSString *settingsFile = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"sqlite3"];
    if (settingsFile == nil) {
        @throw [NSException exceptionWithName:SM_LOCATE_SETTINGS_FILE_FAILED_EXCEPTION reason:@"Could not locate settings file, or the file is corrupt. The required file is settings.sqlite3, and should be available in mainbundle" userInfo:nil];
    }
    return settingsFile;
}

-(void)checkIfStringIsValid:(NSString*)string{
    if(string == nil || [string length] == 0){
        @throw [NSException exceptionWithName:SM_STRING_INVALID_EXCEPTION reason:@"Either a key or value string is either empty or nil" userInfo:nil];
    }
}

-(NSData*)dataFromStatement:(sqlite3_stmt*)statement atColumnIndex:(NSInteger)index{
    const void *ptrToData = sqlite3_column_blob(statement, index);
    int dataSize = sqlite3_column_bytes(statement, index);
    NSData *data = [[NSData alloc] initWithBytes:ptrToData length:dataSize];
    return data;
}

#pragma mark - Object (id) value
-(void)setObject:(id)anObject forKey:(NSString *)key{
    if(anObject == nil){
        @throw [NSException exceptionWithName:SM_NIL_OBJECT_PARAMETER_EXCEPTION reason:@"anObject was nil" userInfo:nil];
    }
    if(![anObject conformsToProtocol:@protocol(NSCoding)]){
        @throw [NSException exceptionWithName:SM_NOT_CONFORMING_TO_NSCODING_EXCEPTION reason:@"anObject does not conform to NSCoding, which is required by NSKeyedArchiver" userInfo:nil];
    }
    [self checkIfStringIsValid:key];
    [self insertObject:anObject forKey:key];
}

-(id)objectForKey:(NSString *)key{
    [self checkIfStringIsValid:key];
    return [self retrieveObjectForKey:key];
}

-(void)insertObject:(id)anObject forKey:(NSString*)key{
    NSString* query = @"INSERT OR REPLACE INTO objects (id_key, value) VALUES (?,?)";
    sqlite3_stmt* statement = [self prepareStatementWithQuery:query];
    [self bindTextToStatement:statement text:key atPosition:1];
    [self bindObjectDataBlobToStatement:statement anObject:anObject atPosition:2];
    [self stepStatement:statement];
    [self finalizeStatement:statement];

}

-(id)retrieveObjectForKey:(NSString*)key{
    NSString* query = @"SELECT value FROM objects WHERE id_key IS (?)";
    sqlite3_stmt* statement = [self prepareStatementWithQuery:query];
    [self bindTextToStatement:statement text:key atPosition:1];
    id value = nil;
    if (sqlite3_step(statement) == SQLITE_ROW) {
        NSData* data = [self dataFromStatement:statement atColumnIndex:0];
        value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    [self finalizeStatement:statement];
    return value;
}

#pragma mark - NSNumber value
-(void)setNumber:(NSNumber*)number forKey:(NSString*)key{
    if(number == nil) {
        @throw [NSException exceptionWithName:SM_NIL_OBJECT_PARAMETER_EXCEPTION reason:@"NSNumber object was nil" userInfo:nil];
    }
    [self checkIfStringIsValid:key];
    [self insertNumber:number forKey:key];
}

-(NSNumber*)numberForKey:(NSString*)key{
    [self checkIfStringIsValid:key];
    return [self retrieveNumberForKey:key];
}


-(NSNumber*)retrieveNumberForKey:(NSString*)key{
    NSString* query = @"SELECT value FROM numbers WHERE id_key IS (?)";
    sqlite3_stmt* statement = [self prepareStatementWithQuery:query];
    [self bindTextToStatement:statement text:key atPosition:1];
    NSNumber* value = nil;
    if (sqlite3_step(statement) == SQLITE_ROW) {
        NSData *data = [self dataFromStatement:statement atColumnIndex:0];
        value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    [self finalizeStatement:statement];
    return value;
}

-(void)insertNumber:(NSNumber*)number forKey:(NSString*)key{
    NSString* query = @"INSERT OR REPLACE INTO numbers (id_key, value) VALUES (?,?)";
    sqlite3_stmt* statement = [self prepareStatementWithQuery:query];
    [self bindTextToStatement:statement text:key atPosition:1];
    [self bindObjectDataBlobToStatement:statement anObject:number atPosition:2];
    [self stepStatement:statement];
    [self finalizeStatement:statement];
}

# pragma mark - string value
-(void)setStringValue:(NSString*)value forKey:(NSString*)key{
    [self checkIfStringIsValid:key];
    [self checkIfStringIsValid:value];
    [self insertStringValue:value forKey:key];
}

-(NSString*)stringValueForKey:(NSString*)key{
    [self checkIfStringIsValid:key];
    return [self retrieveStringValueForKey:key];
}

-(void)insertStringValue:(NSString*)value forKey:(NSString*)key{
    NSString* query = @"INSERT OR REPLACE INTO strings (id_key, value) VALUES (?,?)";
    sqlite3_stmt* statement = [self prepareStatementWithQuery:query];
    [self bindTextToStatement:statement text:key atPosition:1];
    [self bindTextToStatement:statement text:value atPosition:2];
    [self stepStatement:statement];
    [self finalizeStatement:statement];
}

-(NSString*)retrieveStringValueForKey:(NSString*)key{
    NSString* query = @"SELECT value FROM strings WHERE id_key IS (?)";
    sqlite3_stmt* statement = [self prepareStatementWithQuery:query];
    [self bindTextToStatement:statement text:key atPosition:1];
    NSString* value = nil;
    if (sqlite3_step(statement) == SQLITE_ROW) {
        char *title = (char *)sqlite3_column_text(statement, 0);
        value = [NSString stringWithCString:title encoding:NSUTF8StringEncoding];
    }
    [self finalizeStatement:statement];
    return value;
}

# pragma mark - sqlite specific

-(void)finalizeStatement:(sqlite3_stmt*)statement{
    sqlite3_finalize(statement);
}

-(void)stepStatement:(sqlite3_stmt*)statement{
    if (sqlite3_step(statement) != SQLITE_DONE) {
        @throw [NSException exceptionWithName:SM_STATEMENT_STEP_FAILED_EXCEPTION reason:@"Failed to process statement" userInfo:nil];
    }
}

-(void)bindIntegerToStatement:(sqlite3_stmt*)statement integer:(NSInteger)value atPosition:(NSInteger)position{
    if (sqlite3_bind_int64(statement, position, value) != SQLITE_OK) {
        @throw [NSException exceptionWithName:SM_BIND_TO_STATEMENT_FAILED_EXCEPTION reason:@"Failed to bind integer to statement" userInfo:nil];
    }
}

-(void)bindTextToStatement:(sqlite3_stmt*)statement text:(NSString*)value atPosition:(NSInteger)position{
    if (sqlite3_bind_text(statement, position, [value UTF8String], -1, SQLITE_TRANSIENT) != SQLITE_OK) {
        @throw [NSException exceptionWithName:SM_BIND_TO_STATEMENT_FAILED_EXCEPTION reason:@"Failed to bind text to statement" userInfo:nil];
    }
}

-(void)bindObjectDataBlobToStatement:(sqlite3_stmt*)statement anObject:(id)object atPosition:(NSInteger)position{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:object];
    if (sqlite3_bind_blob(statement, position, [data bytes], (int)data.length, NULL) != SQLITE_OK) {
        @throw [NSException exceptionWithName:SM_BIND_TO_STATEMENT_FAILED_EXCEPTION reason:@"Failed to bind datablob to statement" userInfo:nil];
    }
}

-(sqlite3_stmt*)prepareStatementWithQuery:(NSString *)query {
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_databaseConnection, [query UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        @throw [NSException exceptionWithName:SM_PREPARE_STATEMENT_WITH_QUERY_FAILED_EXCEPTION reason:@"Failed to prepare statement with query. Query is probably invalid." userInfo:nil];
    }
    return statement;
}
@end
