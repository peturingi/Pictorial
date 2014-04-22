#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface SQLiteDatabaseConnection : NSObject{
    sqlite3* _connection;
}

-(id)initWithDatabaseFileNamed:(NSString*)filename;
-(sqlite3_stmt*)prepareStatementWithQuery:(NSString*)query;
-(void)finalizeStatement:(sqlite3_stmt*)statement;
-(void)stepStatement:(sqlite3_stmt*)statement;
-(void)bindIntegerToStatement:(sqlite3_stmt*)statement integer:(NSInteger)value atPosition:(NSInteger)position;
-(void)bindTextToStatement:(sqlite3_stmt*)statement text:(NSString*)value atPosition:(NSInteger)position;
-(void)bindDataToStatement:(sqlite3_stmt*)statement data:(NSData*)data atPosition:(NSInteger)position;
-(NSData*)dataFromStatement:(sqlite3_stmt*)statement atColumnIndex:(NSInteger)index;
-(NSString*)stringFromStatement:(sqlite3_stmt*)statement atColumnIndex:(NSInteger)index;
-(NSInteger)integerFromStatement:(sqlite3_stmt*)statement atColumnIndex:(NSInteger)index;
-(NSInteger)lastInsertRowID;
-(BOOL)closeConnection;
-(BOOL)rowExistsFromStatement:(sqlite3_stmt*)statement;
@end
