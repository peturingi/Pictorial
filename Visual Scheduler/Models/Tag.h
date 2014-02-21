//
//  Tag.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 21/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pictogram;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSSet *pictogram;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addPictogramObject:(Pictogram *)value;
- (void)removePictogramObject:(Pictogram *)value;
- (void)addPictogram:(NSSet *)values;
- (void)removePictogram:(NSSet *)values;

@end
