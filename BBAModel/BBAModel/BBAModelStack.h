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
+(void)installInMemoryStoreWithMergedBundle;
+(void)installInMemoryStoreWithModelNamed:(NSString*)modelName;
+(void)installFromMergedBundleWithStoreNamed:(NSString*)storeName;
+(void)installWithModelNamed:(NSString*)modelName andStoreFileNamed:(NSString*)storeFileName;
@end
