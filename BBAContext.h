//
//  BBAContext.h
//  TestCoreData
//
//  Created by Brian Pedersen on 01/03/14.
//  Copyright (c) 2014 TestOrg. All rights reserved.
//

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
