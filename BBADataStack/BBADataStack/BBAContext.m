#import "BBAContext.h"

@implementation BBAContext

#pragma mark - public methods
-(NSManagedObjectContext*)managedObjectContext{
    return _managedObjectContext;
}

+(instancetype)contextWithStore:(NSPersistentStoreCoordinator *)store{
    return [[BBAContext alloc]initWithStore:store];
}

#pragma mark - private methods
-(id)initWithStore:(NSPersistentStoreCoordinator*)store{
    self = [super init];
    if(self){
        [self setupManagedObjectContextWithStore:store];
    }
    return self;
}

-(void)setupManagedObjectContextWithStore:(NSPersistentStoreCoordinator*)store{
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:store];
}

-(void)deleteObject:(NSManagedObject *)anObject{
    [_managedObjectContext deleteObject:anObject];
}

-(void)saveAll{
    BOOL hasChanges = [_managedObjectContext hasChanges];
    if(hasChanges){
        NSError *error = nil;
        BOOL saveSuccess = [_managedObjectContext save:&error];
        if(!saveSuccess){
            [NSException raise:@"Save failed" format:@"The managed object context failed to perform a save. The generated error is: %@", error];
        }
    }
}

-(id)init{
    [NSException raise:@"-init not allowed" format:@"Initialization using standard -init is not allowed - please use the provided classmethod"];
    return nil;
}

@end
