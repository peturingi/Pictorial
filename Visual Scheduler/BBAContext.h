#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BBAContext : NSObject{
    NSManagedObjectContext* _managedObjectContext;
}

+(instancetype)contextWithStore:(NSPersistentStoreCoordinator*)store;
-(NSManagedObjectContext*)managedObjectContext;
-(void)deleteObject:(NSManagedObject*)anObject;
-(void)saveAll;

@end
