#import "BBAPictogramCreator.h"
#import "../../BBACoreDataStack.h"

@interface BBAPictogramCreator ()
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *title;
@end

@implementation BBAPictogramCreator

+ (void)savePictogramFromUserInputWith:(NSString *)title with:(UIImage *)image {
    BBAPictogramCreator *pictogramCreator = [[BBAPictogramCreator alloc] init];
    pictogramCreator.title = title;
    pictogramCreator.image = image;
    [pictogramCreator createPictogramFromUserInput];
}

- (void)createPictogramFromUserInput {
    NSString *destination = [self destinationForPictogram];
    [self saveImageAt:destination];
    [[BBACoreDataStack sharedInstance] insertPictogramWithTitle:self.title andLocation:destination];
}

- (void)saveImageAt:(NSString *)destination {
    NSData *imageData = UIImagePNGRepresentation(self.image);
    [imageData writeToFile:destination atomically:YES];
}

- (NSString *)destinationForPictogram {
    NSString *uniqueFileName = [self uniqueFileName];
    NSString *documentDir = [self documentDirectory];
    return [documentDir stringByAppendingString:uniqueFileName];
}

- (NSString *)uniqueFileName {
    NSString *prefix = @"pictogram-";
    NSString *uniqueString = [[NSProcessInfo processInfo] globallyUniqueString];
    return [prefix stringByAppendingString:uniqueString];
}

- (NSString *)documentDirectory {
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [dirPaths firstObject];
}

@end
