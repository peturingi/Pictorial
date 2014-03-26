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

#pragma mark -

- (Schedule *)scheduleWithTitle:(NSString *)title withColor:(UIColor *)color {
    NSDictionary *content = @{@"title" : title,
                              @"color" : [NSNumber numberWithInteger:[BBAColor indexForColor:color]]};
    NSInteger uniqueIdentifier = [_dataStore createSchedule:content];
    Schedule *schedule = [[Schedule alloc] init];
    [schedule setUniqueIdentifier:uniqueIdentifier];
    [schedule setTitle:title];
    [schedule setColor:color];
    return schedule;
}

@end
