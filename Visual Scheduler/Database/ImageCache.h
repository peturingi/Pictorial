//
//  ImageCache.h
//  Visual Scheduler
//
//  Created by Brian Pedersen on 21/04/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject{
    NSMutableDictionary* _cache;
}

-(void)insertImage:(UIImage*)image atIndex:(NSInteger)index;
-(UIImage*)imageAtIndex:(NSInteger)index;
- (BOOL)containsImageAtIndex:(NSInteger)index;

@end
