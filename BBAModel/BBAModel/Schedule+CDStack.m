#import "Schedule+CDStack.h"

static NSUInteger const kBBAScheduleBatchSize = 20;

@implementation Schedule (CDStack)

+(instancetype)insert{
    id instance = [[[self class]cdstack]insertNewManagedObjectFromClass:[self class]];
    return instance;
}

+ (void)insertWithTitle:(NSString *)title logo:(Pictogram *)pictogram backGround:(NSUInteger)colorIndex {
    id schedule = [[self class] insert];
    [schedule setTitle:title];
    [schedule setDate:[NSDate date]];
    [schedule setColour:[NSNumber numberWithUnsignedInteger:colorIndex]];
    [schedule setLogo:pictogram];
    [[self class] save];
}

+(void)save{
    [[[self class] cdstack]saveAll];
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
