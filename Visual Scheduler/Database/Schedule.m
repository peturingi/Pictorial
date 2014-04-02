#import "Schedule.h"
#import "Repository.h"

@implementation Schedule

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

@end
