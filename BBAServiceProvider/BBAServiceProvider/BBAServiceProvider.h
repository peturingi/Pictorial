//
//  BBAServiceProvider.h
//  BBAServiceProvider
//
//  Created by Brian Pedersen on 04/03/14.
//  Copyright (c) 2014 BBA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBAServiceProvider : NSObject

+(id)serviceFromClass:(Class)aClass;
+(void)insertService:(id)service;
+(void)deleteServiceOfClass:(Class)aClass;

@end
