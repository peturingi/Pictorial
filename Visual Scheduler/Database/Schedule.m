#import "Schedule.h"
#import "Repository.h"

@implementation Schedule {
    NSArray *_pictograms;
}

- (id)initWithTitle:(NSString *)title withColor:(UIColor *)color withUniqueIdentifier:(NSInteger)identifier {
    self = [super init];
    if (self) {
        _uniqueIdentifier = identifier;
        self.title = title;
        self.color = color;
    }
    return self;
}

- (NSArray *)pictograms {
    if (_pictograms == nil) {
        _pictograms = [[Repository sharedStore] pictogramsForSchedule:self includingImages:YES];
    }
    return _pictograms;
}

- (void)setPictograms:(NSArray *)pictograms {
    // TODO possible race condition.
    [[Repository sharedStore]removeAllPictogramsFromSchedule:self];
    for (NSUInteger i = 0; i < pictograms.count; i++) {
        [[Repository sharedStore] addPictogram:[pictograms objectAtIndex:i] toSchedule:self atIndex:i];
    }
    _pictograms = pictograms;
}

@end
