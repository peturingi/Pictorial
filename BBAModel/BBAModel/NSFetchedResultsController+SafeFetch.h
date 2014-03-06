//
//  NSFetchedResultsController+SafeFetch.h
//  BBAModel
//
//  Created by Brian Pedersen on 05/03/14.
//  Copyright (c) 2014 BBA. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchedResultsController (SafeFetch)

-(void)errorHandledFetch;

@end
