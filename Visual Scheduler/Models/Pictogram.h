//
//  Pictogram.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 20/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContainsImage.h"

@interface Pictogram : NSObject <ContainsImage>

@property (copy)        NSString       *title;
@property (readonly)    UIImage        *image;
@property (readonly)    NSMutableArray *tags;

- (id)initWithImage:(NSString *)imageNamed;

@end
