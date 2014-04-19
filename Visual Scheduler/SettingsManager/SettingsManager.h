#define SM_STRING_INVALID_EXCEPTION @"SMKeyOrValueStringInvalid"
#define SM_NIL_OBJECT_PARAMETER_EXCEPTION @"SMNilObjectParameter"
#define SM_NOT_CONFORMING_TO_NSCODING_EXCEPTION @"SMObjectNotConformingToNSCoding"

 
#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SQLiteDatabaseConnection.h"

@interface SettingsManager : NSObject {
    SQLiteDatabaseConnection* _dbcon;
}

-(void)setStringValue:(NSString*)value forKey:(NSString*)key;
-(NSString*)stringValueForKey:(NSString*)key;

-(void)setNumber:(NSNumber*)number forKey:(NSString*)key;
-(NSNumber*)numberForKey:(NSString*)key;

-(void)setObject:(id)anObject forKey:(NSString*)key;
-(id)objectForKey:(NSString*)key;

@end
