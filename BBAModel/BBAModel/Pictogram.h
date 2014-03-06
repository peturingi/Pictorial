//
//  Pictogram.h
//  BBAModel
//
//  Created by Brian Pedersen on 04/03/14.
//  Copyright (c) 2014 BBA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, PictoCategory;

@interface Pictogram : NSManagedObject

@property (nonatomic, retain) NSNumber * favorited;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *category;
@property (nonatomic, retain) NSSet *activity;
@end

@interface Pictogram (CoreDataGeneratedAccessors)

- (void)addCategoryObject:(PictoCategory *)value;
- (void)removeCategoryObject:(PictoCategory *)value;
- (void)addCategory:(NSSet *)values;
- (void)removeCategory:(NSSet *)values;

- (void)addActivityObject:(Activity *)value;
- (void)removeActivityObject:(Activity *)value;
- (void)addActivity:(NSSet *)values;
- (void)removeActivity:(NSSet *)values;

@end
