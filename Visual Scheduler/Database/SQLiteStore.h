#import <Foundation/Foundation.h>
#import "DataStoreProtocol.h"
#import "sqlite3.h"
#import "../SettingsManager/SQLiteDatabaseConnection.h"

@interface SQLiteStore : NSObject <DataStoreProtocol> {
    sqlite3 *_databaseConnection;
    SQLiteDatabaseConnection* _dbcon;
}
@end