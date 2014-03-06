//
//  BBAModelStack.h
//  BBAModel
//
//  Created by Brian Pedersen on 05/03/14.
//  Copyright (c) 2014 BBA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Activity+CDStack.h"
#import "PictoCategory+CDStack.h"
#import "Pictogram+CDStack.h"
#import "Schedule+CDStack.h"
#import "NSFetchedResultsController+SafeFetch.h"

@interface BBAModelStack : NSObject

+(void)save;
+(void)modelNamed:(NSString*)name andStore:(NSString*)store;
+(void)modelWithStoreInMemoryNamed:(NSString*)name;
@end
