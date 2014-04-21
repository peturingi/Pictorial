//
//  ImageCache.m
//  Visual Scheduler
//
//  Created by Brian Pedersen on 21/04/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache

-(id)init{
    self = [super init];
    if(self){
        _cache = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)insertImage:(UIImage *)image atIndex:(NSInteger)index{
    [_cache setObject:image forKey:[NSNumber numberWithInteger:index]];
}

-(UIImage*)imageAtIndex:(NSInteger)index{
    return [_cache objectForKey:[NSNumber numberWithInteger:index]];
}
@end
