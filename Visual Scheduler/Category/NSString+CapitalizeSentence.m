//
//  NSString+CapitalizeSentence.m
//  Visual Scheduler
//
//  Created by Brian Pedersen on 20/04/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import "NSString+CapitalizeSentence.h"

@implementation NSString (CapitalizeSentence)
-(NSString*)capitalizedSentence{
    return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] capitalizedString]];
}
@end
