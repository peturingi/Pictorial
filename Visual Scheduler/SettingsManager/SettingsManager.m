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
        @throw [NSException exceptionWithName:@"Could not establish connection to database." reason:@"Unknown" userInfo:nil];
    }
}

-(NSString*)locateSettingsFile{
    NSString *settingsFile = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"sqlite3"];
    if (settingsFile == nil) {
        @throw [NSException exceptionWithName:@"SQLite3 databasefile was not found." reason:@"Unknown" userInfo:nil];
    }
    return settingsFile;
}

-(void)checkIfStringIsValid:(NSString*)string{
    if(string == nil || [string length] == 0){
        @throw [NSException exceptionWithName:@"Key or string value was invalid" reason:@"Invalid string" userInfo:nil];
    }
}

#pragma mark - NSNumber value
-(void)setNumber:(NSNumber*)number forKey:(NSString*)key{
    if(number == nil) {
        @throw [NSException exceptionWithName:@"Number object cannot be nil" reason:@"NSNumber object was nil" userInfo:nil];
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
    NSNumber* value;
    if (sqlite3_step(statement) == SQLITE_ROW) {
        const void *ptrToData = sqlite3_column_blob(statement, 0);
        int dataSize = sqlite3_column_bytes(statement, 0);
        NSData *data = [[NSData alloc] initWithBytes:ptrToData length:dataSize];
        value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }else{
        @throw [NSException exceptionWithName:@"Invalid tuple" reason:@"Could not find tuple for key" userInfo:nil];
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
    NSString* value;
    if (sqlite3_step(statement) == SQLITE_ROW) {
        char *title = (char *)sqlite3_column_text(statement, 0);
        value = [NSString stringWithCString:title encoding:NSUTF8StringEncoding];
    }else{
        @throw [NSException exceptionWithName:@"Invalid tuple" reason:@"Could not find tuple for key" userInfo:nil];
    }
    [self finalizeStatement:statement];
    return value;
}

# pragma mark - integer value
-(void)setIntegerValue:(NSInteger)value forKey:(NSString *)key{
    [self checkIfStringIsValid:key];
    [self insertIntegerValue:value forKey:key];
}

-(NSInteger)integerValueForKey:(NSString *)key{
    [self checkIfStringIsValid:key];
    return [self retrieveIntegerValueForKey:key];
}

-(void)insertIntegerValue:(NSInteger)value forKey:(NSString*)key{
    NSString* query = @"INSERT OR REPLACE INTO integers (id_key, value) VALUES (?,?)";
    sqlite3_stmt* statement = [self prepareStatementWithQuery:query];
    [self bindTextToStatement:statement text:key atPosition:1];
    [self bindIntegerToStatement:statement integer:value atPosition:2];
    [self stepStatement:statement];
    [self finalizeStatement:statement];
}

-(NSInteger)retrieveIntegerValueForKey:(NSString*)key{
    NSString* query = @"SELECT value FROM integers WHERE id_key IS (?)";
    sqlite3_stmt* statement = [self prepareStatementWithQuery:query];
    [self bindTextToStatement:statement text:key atPosition:1];
    NSInteger value;
    if (sqlite3_step(statement) == SQLITE_ROW) {
        value = sqlite3_column_int(statement, 0);
    }else{
        @throw [NSException exceptionWithName:@"Invalid tuple" reason:@"Could not find tuple for key" userInfo:nil];
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
        @throw [NSException exceptionWithName:@"SQLite3 error." reason:@"Failed to process statement" userInfo:nil];
    }
}

-(void)bindIntegerToStatement:(sqlite3_stmt*)statement integer:(NSInteger)value atPosition:(NSInteger)position{
    if (sqlite3_bind_int64(statement, position, value) != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"SQLite3 error." reason:@"Failed to bind integer to statement" userInfo:nil];
    }
}

-(void)bindTextToStatement:(sqlite3_stmt*)statement text:(NSString*)value atPosition:(NSInteger)position{
    if (sqlite3_bind_text(statement, position, [value UTF8String], -1, SQLITE_TRANSIENT) != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"SQLite3 error." reason:@"Failed to bind text to statement" userInfo:nil];
    }
}

-(void)bindObjectDataBlobToStatement:(sqlite3_stmt*)statement anObject:(id)object atPosition:(NSInteger)position{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:object];
    if (sqlite3_bind_blob(statement, position, [data bytes], (int)data.length, NULL) != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"SQLite3 error." reason:@"Failed to bind data blob to statement" userInfo:nil];
    }
}

-(sqlite3_stmt*)prepareStatementWithQuery:(NSString *)query {
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_databaseConnection, [query UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"SQLite3 error" reason:@"Failed to prepare statement with query. Query is probably invalid." userInfo:nil];
    }
    return statement;
}
@end
