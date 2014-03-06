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

+(void)insertWithTile:(NSString*)title imageLogo:(UIImage*)image andBackgroundColor:(NSUInteger)colorIndex{
    id schedule = [[self class]insert];
    // TODO: save image
    [schedule setTitle:title];
    [schedule setDate:[NSDate date]];
    [schedule setColour:[NSNumber numberWithUnsignedInteger:colorIndex]];
    [[self class]save];
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
