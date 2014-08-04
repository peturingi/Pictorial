//
//  Pictogram.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 04/08/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PictogramContainer;

@interface Pictogram : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *usedBy;

- (UIImage *)uiImage;

@end

@interface Pictogram (CoreDataGeneratedAccessors)

- (void)addUsedByObject:(PictogramContainer *)value;
- (void)removeUsedByObject:(PictogramContainer *)value;
- (void)addUsedBy:(NSSet *)values;
- (void)removeUsedBy:(NSSet *)values;

@end
