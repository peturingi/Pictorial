//
//  CameraDelegate.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 22/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CameraDelegate <NSObject>

@optional
/** The camera did disappear.
 */
- (void)cameraDidDisappear;

/** The camere has appeared and is ready for use.
 */
- (void)cameraAppeared;

/** The camera snapped a photo and is about to disappear.
 */
- (void)cameraSnappedPhoto;

@end
