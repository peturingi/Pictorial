//
//  ContainsImage.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 20/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ContainsImageData <NSObject>

@required
@property (nonatomic, retain) NSData *image;

@end
