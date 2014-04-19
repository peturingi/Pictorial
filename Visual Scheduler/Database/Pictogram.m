#import "Pictogram.h"
#import "Repository.h"

@implementation Pictogram

- (id)initWithTitle:(NSString *)title withUniqueIdentifier:(NSInteger)identifier withImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _uniqueIdentifier = identifier;
        self.title = title;
        _image = image;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Title: %@", self.title];
}

-(UIImage*)image{
    if(_image == nil){
        _image = [[Repository sharedStore] imageForPictogram:self];
    }
    return _image;
}
@end
