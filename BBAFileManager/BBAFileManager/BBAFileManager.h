//
//  BBAFileManager.h
//  BBAFileManager
//
//  Created by Brian Pedersen on 05/03/14.
//  Copyright (c) 2014 BBA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BBAFileManager : NSObject
+(NSString*)uniqueFileNameWithPrefix:(NSString*)prefix;
+(void)saveImage:(UIImage*)image atLocation:(NSString*)location;
@end
