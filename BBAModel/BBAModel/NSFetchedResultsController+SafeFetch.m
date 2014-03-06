#import "NSFetchedResultsController+SafeFetch.h"

@implementation NSFetchedResultsController (SafeFetch)

-(void)errorHandledFetch{
    NSError* error = nil;
    BOOL success = [self performFetch:&error];
    if(!success){
        [NSException raise:@"Failed to fetch" format:@"The fetched results controller failed to perform a fetch. The generated error is: %@", error];
    }
}

@end
