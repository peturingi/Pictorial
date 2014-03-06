//
//  TestEntity.h
//  TestCoreData
//
//  Created by Brian Pedersen on 02/03/14.
//  Copyright (c) 2014 TestOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TestEntity : NSManagedObject

@property (nonatomic, retain) NSDate * timestamp;

@end
