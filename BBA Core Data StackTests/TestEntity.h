//
//  TestEntity.h
//  Visual Scheduler
//
//  Created by Brian Pedersen on 03/03/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TestEntity : NSManagedObject

@property (nonatomic, retain) NSDate * timestamp;

@end
