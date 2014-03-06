//
//  Pictogram+CDStack.m
//  BBAModel
//
//  Created by Brian Pedersen on 05/03/14.
//  Copyright (c) 2014 BBA. All rights reserved.
//

#import "Pictogram+CDStack.h"

static NSUInteger const kBBAPictogramBatchSize = 20;

@implementation Pictogram (CDStack)

+(void)insertWithTitle:(NSString*)title andImage:(UIImage*)image{
    id pictogram = [[self class]insert];
    NSString* location = [BBAFileManager uniqueFileNameWithPrefix:@"pictogram"];
    [pictogram setTitle:title];
    [pictogram setImageURL:location];
    [BBAFileManager saveImage:image atLocation:location];
    [[self class] save];
}

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
    [request setFetchBatchSize:kBBAPictogramBatchSize];
    return [[self cdstack] fetchedResultsControllerFromFetchRequest:request];
}

+(BBADataStack*)cdstack{
    return [BBAServiceProvider serviceFromClass:[BBADataStack class]];
}

@end
