//
//  Pictogram.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 21/03/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Schedule;

@interface Pictogram : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *usedBy;
@end

@interface Pictogram (CoreDataGeneratedAccessors)

- (void)addUsedByObject:(Schedule *)value;
- (void)removeUsedByObject:(Schedule *)value;
- (void)addUsedBy:(NSSet *)values;
- (void)removeUsedBy:(NSSet *)values;

@end
