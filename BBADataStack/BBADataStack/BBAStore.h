//
//  BBAPersistentStore.h
//  TestCoreData
//
//  Created by Brian Pedersen on 01/03/14.
//  Copyright (c) 2014 TestOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BBAStore : NSObject{
    NSPersistentStoreCoordinator* _persistentStoreCoordinator;
}

+(instancetype)storeWithModel:(NSManagedObjectModel*)model andStoreFileURL:(NSURL*)storeFileURL;
-(NSPersistentStoreCoordinator*)persistentStoreCoordinator;

@end
