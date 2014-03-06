//
//  Schedule+CDStack.m
//  BBAModel
//
//  Created by Brian Pedersen on 04/03/14.
//  Copyright (c) 2014 BBA. All rights reserved.
//

#import "Schedule+CDStack.h"

static NSUInteger const kBBAScheduleBatchSize = 20;

@implementation Schedule (CDStack)

+(void)save{
    [[[self class] cdstack]saveAll];
}

+(instancetype)insert{
    id instance = [[[self class]cdstack]insertNewManagedObjectFromClass:[self class]];
    return instance;
}

+(NSFetchedResultsController*)fetchedResultsController{
    NSSortDescriptor* descriptor = [[NSSortDescriptor alloc]initWithKey:@"title" ascending:YES];
    NSArray* sortDescriptors = @[descriptor];
    NSFetchRequest* request = [[self cdstack] fetchRequestForEntityClass:[self class]];
    [request setSortDescriptors:sortDescriptors];
    [request setFetchBatchSize:kBBAScheduleBatchSize];
    return [[self cdstack] fetchedResultsControllerFromFetchRequest:request];
}

+(BBADataStack*)cdstack{
    return [BBAServiceProvider serviceFromClass:[BBADataStack class]];
}
@end
