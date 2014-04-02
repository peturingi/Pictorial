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
    for (Pictogram *pictogram in pictograms) {
        [[Repository sharedStore] addPictogram:pictogram toSchedule:self atIndex:[pictograms indexOfObject:pictogram]];
    }
    _pictograms = pictograms;
}

@end
