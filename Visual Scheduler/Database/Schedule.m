#import "Schedule.h"

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

@end
