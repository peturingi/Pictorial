#import "SettingsManager.h"
@implementation SettingsManager
-(id)init{
    self = [super init];
    if(self){
        _dbcon = [[SQLiteDatabaseConnection alloc]initWithDatabaseFileNamed:@"settings"];
    }
    return self;
}

-(void)dealloc{
    [_dbcon closeConnection];
}

-(void)checkIfStringIsValid:(NSString*)string{
    if(string == nil || [string length] == 0){
        @throw [NSException exceptionWithName:SM_STRING_INVALID_EXCEPTION reason:@"Either a key or value string is either empty or nil" userInfo:nil];
    }
}

-(void)checkObjectIsNotNil:(id)anObject{
    if(anObject == nil){
        @throw [NSException exceptionWithName:SM_NIL_OBJECT_PARAMETER_EXCEPTION reason:@"anObject was nil" userInfo:nil];
    }
}

-(void)checkObjectConformsToNSCoding:(id)anObject{
    if(![anObject conformsToProtocol:@protocol(NSCoding)]){
        @throw [NSException exceptionWithName:SM_NOT_CONFORMING_TO_NSCODING_EXCEPTION reason:@"anObject does not conform to NSCoding, which is required by NSKeyedArchiver" userInfo:nil];
    }
}

#pragma mark - Object (id) value
-(void)setObject:(id)anObject forKey:(NSString *)key{
    [self checkObjectIsNotNil:anObject];
    [self checkObjectConformsToNSCoding:anObject];
    [self checkIfStringIsValid:key];
    NSString* query = @"INSERT OR REPLACE INTO objects (id_key, value) VALUES (?,?)";
    sqlite3_stmt* statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindTextToStatement:statement text:key atPosition:1];
    [_dbcon bindObjectDataBlobToStatement:statement anObject:anObject atPosition:2];
    [_dbcon stepStatement:statement];
    [_dbcon finalizeStatement:statement];
}

-(id)objectForKey:(NSString *)key{
    [self checkIfStringIsValid:key];
    NSString* query = @"SELECT value FROM objects WHERE id_key IS (?)";
    sqlite3_stmt* statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindTextToStatement:statement text:key atPosition:1];
    id value = nil;
    if ([_dbcon rowExistsFromStatement:statement]) {
        NSData* data = [_dbcon dataFromStatement:statement atColumnIndex:0];
        value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    [_dbcon finalizeStatement:statement];
    return value;
}

#pragma mark - NSNumber value
-(void)setNumber:(NSNumber*)number forKey:(NSString*)key{
    [self checkObjectIsNotNil:number];
    [self checkIfStringIsValid:key];
    NSString* query = @"INSERT OR REPLACE INTO numbers (id_key, value) VALUES (?,?)";
    sqlite3_stmt* statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindTextToStatement:statement text:key atPosition:1];
    [_dbcon bindObjectDataBlobToStatement:statement anObject:number atPosition:2];
    [_dbcon stepStatement:statement];
    [_dbcon finalizeStatement:statement];
    
}

-(NSNumber*)numberForKey:(NSString*)key{
    [self checkIfStringIsValid:key];
    NSString* query = @"SELECT value FROM numbers WHERE id_key IS (?)";
    sqlite3_stmt* statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindTextToStatement:statement text:key atPosition:1];
    NSNumber* value = nil;
    if ([_dbcon rowExistsFromStatement:statement]) {
        NSData *data = [_dbcon dataFromStatement:statement atColumnIndex:0];
        value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    [_dbcon finalizeStatement:statement];
    return value;
}

# pragma mark - string value
-(void)setStringValue:(NSString*)value forKey:(NSString*)key{
    [self checkIfStringIsValid:key];
    [self checkIfStringIsValid:value];
    NSString* query = @"INSERT OR REPLACE INTO strings (id_key, value) VALUES (?,?)";
    sqlite3_stmt* statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindTextToStatement:statement text:key atPosition:1];
    [_dbcon bindTextToStatement:statement text:value atPosition:2];
    [_dbcon stepStatement:statement];
    [_dbcon finalizeStatement:statement];
}

-(NSString*)stringValueForKey:(NSString*)key{
    [self checkIfStringIsValid:key];
    NSString* query = @"SELECT value FROM strings WHERE id_key IS (?)";
    sqlite3_stmt* statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindTextToStatement:statement text:key atPosition:1];
    NSString* value = nil;
    if ([_dbcon rowExistsFromStatement:statement]) {
        value = [_dbcon stringFromStatement:statement atColumnIndex:0];
    }
    [_dbcon finalizeStatement:statement];
    return value;
}
@end
