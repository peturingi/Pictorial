#import "Pictogram.h"

@implementation Pictogram

- (id)initWithTitle:(NSString *)title withUniqueIdentifier:(NSInteger)identifier withImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _uniqueIdentifier = identifier;
        self.title = title;
        self.image = image;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Title: %@", self.title];
}
@end
