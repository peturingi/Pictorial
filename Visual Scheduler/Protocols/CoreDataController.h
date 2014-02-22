//
//  CoreDataController.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 22/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CoreDataController <NSObject>
@required
    - (void)saveContext;
@end
