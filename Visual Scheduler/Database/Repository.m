#import "Repository.h"
#import "BBAColor.h"

@implementation Repository

#pragma mark - Constructor / Deconstructor

- (id)initWithStore:(id<DataStoreProtocol>)store {
    NSParameterAssert(store != nil);
    self = [super init];
    if (self) {
        _dataStore = store;
    }
    return self;
}

- (void)dealloc {
    _dataStore = nil;
}

#pragma mark - Create

- (Schedule *)scheduleWithTitle:(NSString *)title withColor:(UIColor *)color {
    NSParameterAssert(title != nil);
    NSParameterAssert(color != nil);
    NSDictionary *content = @{@"title" : title,
                              @"color" : [NSNumber numberWithInteger:[BBAColor indexForColor:color]]};
    NSInteger uniqueIdentifier = [_dataStore createSchedule:content];
    Schedule *schedule = [[Schedule alloc] initWithTitle:title withColor:color withUniqueIdentifier:uniqueIdentifier];
    return schedule;
}

- (Pictogram *)pictogramWithTitle:(NSString *)title withImage:(UIImage *)image {
    NSParameterAssert(title != nil);
    NSParameterAssert(image != nil);
    NSDictionary *content = @{@"title" : title,
                              @"image" : UIImagePNGRepresentation(image)};
    NSInteger uniqueIdentifier = [_dataStore createPictogram:content];
    Pictogram *pictogram = [[Pictogram alloc] initWithTitle:title withUniqueIdentifier:uniqueIdentifier withImage:image ];
    return pictogram;
}

#pragma mark - Retrieve

- (NSArray *)allSchedules {
    NSMutableArray *schedules = [NSMutableArray array];
    NSArray *rawSchedules = [_dataStore contentOfAllSchedules];
    for (NSDictionary *dict in rawSchedules) {
        NSNumber *uniqueIdentifier = [dict valueForKey:@"id"];
        NSString *title = [dict valueForKey:@"title"];
        UIColor *color = [BBAColor colorForIndex:[[dict valueForKey:@"color"] integerValue]];
        Schedule *schedule = [[Schedule alloc] initWithTitle:title withColor:color withUniqueIdentifier:uniqueIdentifier.integerValue];
        [schedules addObject:schedule];
    }
    return schedules;
}

- (NSArray *)allPictograms {
    NSMutableArray *pictograms = [NSMutableArray array];
    NSArray *rawPictograms = [_dataStore contentOfAllPictogramsIncludingImageData:NO];
    for (NSDictionary *dict in rawPictograms) {
        NSNumber *uniqueIdentifier = [dict valueForKey:@"id"];
        NSString *title = [dict valueForKey:@"title"];
        Pictogram *pictogram = [[Pictogram alloc] initWithTitle:title withUniqueIdentifier:uniqueIdentifier.integerValue withImage:nil];
        [pictograms addObject:pictogram];
    }
    return pictograms;
}

@end
