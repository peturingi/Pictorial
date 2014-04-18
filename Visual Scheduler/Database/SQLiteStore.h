#import <Foundation/Foundation.h>
#import "DataStoreProtocol.h"
#import "sqlite3.h"

@interface SQLiteStore : NSObject <DataStoreProtocol> {
    sqlite3 *_databaseConnection;
}
@end