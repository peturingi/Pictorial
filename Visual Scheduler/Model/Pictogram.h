//
//  Pictogram.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 03/03/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PictoCategory;

@interface Pictogram : NSManagedObject

@property (nonatomic, retain) NSNumber * favorited;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *category;
@end

@interface Pictogram (CoreDataGeneratedAccessors)

- (void)addCategoryObject:(PictoCategory *)value;
- (void)removeCategoryObject:(PictoCategory *)value;
- (void)addCategory:(NSSet *)values;
- (void)removeCategory:(NSSet *)values;

@end
