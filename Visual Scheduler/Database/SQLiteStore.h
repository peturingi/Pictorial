#import <Foundation/Foundation.h>
#import "DataStoreProtocol.h"
#import "../SettingsManager/SQLiteDatabaseConnection.h"

@interface SQLiteStore : NSObject <DataStoreProtocol> {
    SQLiteDatabaseConnection* _dbcon;
}
@end