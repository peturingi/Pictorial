//
//  Pictogram.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 21/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ContainsImageAsData.h"

@interface Pictogram : NSManagedObject <ContainsImageData>

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * title;

@end
