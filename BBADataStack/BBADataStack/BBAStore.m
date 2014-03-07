#import "BBAStore.h"

@implementation BBAStore

#pragma mark - public methods
+(instancetype)storeWithModel:(NSManagedObjectModel *)model andStoreFileURL:(NSURL *)storeFileURL{
    return [[BBAStore alloc]initWithModel:model andStoreFileURL:storeFileURL];
}

+(instancetype)inMemoryStoreWithModel:(NSManagedObjectModel *)model{
    return [[BBAStore alloc]initInMemoryWithModel:model];
}

-(void)setupPersitentCoordinator:(NSManagedObjectModel*)model storeType:(NSString*)type andStoreFile:(NSURL*)storeFile{
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSError *error = nil;
    NSDictionary* options = @{NSMigratePersistentStoresAutomaticallyOption: @YES};
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                   configuration:nil
                                                             URL:nil
                                                         options:options
                                                           error:&error]){
        [NSException raise:@"Failed to initialize persistency store" format:@"Failed to initialize the persistent store coordinator with the provided options. This is either due to a failed migration or an invalid store file url. The generated error is: %@", error];
    }
}

-(NSPersistentStoreCoordinator*)persistentStoreCoordinator{
    return _persistentStoreCoordinator;
}

#pragma mark - private methods
-(id)initWithModel:(NSManagedObjectModel*)model andStoreFileURL:(NSURL*)storeFileURL{
    self = [super init];
    if(self){
        [self verifyModel:model];
        [self verifyStoreFileURL:storeFileURL];
        [self setupPersitentCoordinator:model storeType:NSSQLiteStoreType andStoreFile:storeFileURL];
    }
    return self;
}

-(id)initInMemoryWithModel:(NSManagedObjectModel*)model{
    self = [super init];
    if(self){
        [self verifyModel:model];
        [self setupPersitentCoordinator:model storeType:NSInMemoryStoreType andStoreFile:nil];
    }
    return self;
}

-(void)verifyModel:(NSManagedObjectModel*)model{
    if(!model){
        [NSException raise:@"Model was nil" format:@"Cannot initialize the store provided a nil model"];
    }
}

-(void)verifyStoreFileURL:(NSURL*)storeFileURL{
    if(!storeFileURL){
        [NSException raise:@"storeFileURL was nil" format:@"Provided storeFileURL was nil"];
    }
    if(![storeFileURL isFileURL]){
        
        [NSException raise:@"storeFileURL was not a file" format:@"storeFileURL was not a valid URL for a file location"];
    }
}

-(id)init __deprecated{
    [NSException raise:@"-init not allowed" format:@"Initialization using standard -init is not allowed - please use the provided classmethod"];
    return nil;
}

@end
