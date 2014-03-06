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

+(void)save{
    [[[self class]datastack]saveAll];
}

+(void)modelNamed:(NSString*)name andStore:(NSString*)store{
    BBADataStack* datastack = [BBADataStack stackWithModelNamed:name andStoreFileNamed:store];
    [BBAServiceProvider insertService:datastack];
    
}

+(void)modelWithStoreInMemoryNamed:(NSString*)name{
    BBADataStack* datastack = [BBADataStack stackInMemoryWithModelNamed:name];
    [BBAServiceProvider insertService:datastack];
}

+(BBADataStack*)datastack{
    return [BBAServiceProvider serviceFromClass:[BBADataStack class]];
}
@end
