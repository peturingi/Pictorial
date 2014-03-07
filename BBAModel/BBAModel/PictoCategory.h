//
//  PictoCategory.h
//  BBAModel
//
//  Created by Brian Pedersen on 06/03/14.
//  Copyright (c) 2014 BBA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pictogram;

@interface PictoCategory : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *pictogram;
@end

@interface PictoCategory (CoreDataGeneratedAccessors)

- (void)addPictogramObject:(Pictogram *)value;
- (void)removePictogramObject:(Pictogram *)value;
- (void)addPictogram:(NSSet *)values;
- (void)removePictogram:(NSSet *)values;

@end