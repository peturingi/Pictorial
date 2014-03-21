#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BBAStore : NSObject{
    NSPersistentStoreCoordinator* _persistentStoreCoordinator;
}

+(instancetype)storeWithModel:(NSManagedObjectModel*)model andStoreFileURL:(NSURL*)storeFileURL;
+(instancetype)inMemoryStoreWithModel:(NSManagedObjectModel*)model;
-(NSPersistentStoreCoordinator*)persistentStoreCoordinator;

@end
