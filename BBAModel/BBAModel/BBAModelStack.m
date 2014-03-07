//
//  BBAModelStack.m
//  BBAModel
//
//  Created by Brian Pedersen on 05/03/14.
//  Copyright (c) 2014 BBA. All rights reserved.
//

#import "BBAModelStack.h"
#import "../../BBAServiceProvider/BBAServiceProvider/BBAServiceProvider.h"
#import "../../BBADataStack/BBADataStack/BBADataStack.h"

@implementation BBAModelStack
+(void)installInMemoryStoreWithMergedBundle{
    BBADataStack* datastack = [BBADataStack stackInMemoryStoreFromMergedModelBundle];
    [BBAServiceProvider insertService:datastack];
}

+(void)installInMemoryStoreWithModelNamed:(NSString*)modelName{
    BBADataStack* datastack = [BBADataStack stackInMemoryWithModelNamed:modelName];
    [BBAServiceProvider insertService:datastack];
}

+(void)installFromMergedBundleWithStoreNamed:(NSString*)storeName{
    BBADataStack* datastack = [BBADataStack stackFromMergedModelBundleAndStoreNamed:storeName];
    [BBAServiceProvider insertService:datastack];
}

+(void)installWithModelNamed:(NSString*)modelName andStoreFileNamed:(NSString*)storeFileName{
    BBADataStack* datastack = [BBADataStack stackWithModelNamed:modelName andStoreFileNamed:storeFileName];
    [BBAServiceProvider insertService:datastack];
}

+(void)save{
    [[[self class]datastack]saveAll];
}

+(BBADataStack*)datastack{
    return [BBAServiceProvider serviceFromClass:[BBADataStack class]];
}
@end
