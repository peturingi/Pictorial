#import "BBANewPictogramViewController.h"
#import "Camera.h"
#import "Pictogram.h"
#import "../../BBACoreDataStack.h"

@interface BBANewPictogramViewController ()
@end

@implementation BBANewPictogramViewController

- (void)viewWillAppear:(BOOL)animated {
    [photoView setImage:self.photo];
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewController];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButton:(id)sender {
    if ([self verifyTitle]) {
        [self createPictogramFromUserInput];
        [self dismissViewController];
    } else {
        [self alertUserOfInvalidTitle];
    }
}

- (BOOL)verifyTitle {
    return ([photoTitle.text length] > 0) ? YES : NO;
}

- (void)alertUserOfInvalidTitle {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You must specify a title." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)createPictogramFromUserInput {
    NSString *destination = [self destinationForPictogram];
    [self saveImageAt:destination];
    [[BBACoreDataStack sharedInstance] insertPictogramWithTitle:photoTitle.text andLocation:destination];
}

- (void)saveImageAt:(NSString *)destination {
    NSData *imageData = UIImagePNGRepresentation(self.photo);
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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)notifyDelegateOfPictogramCreation {
    SEL delegateMethod = NSSelectorFromString(@"BBANewPictogramViewControllerCreatedPictogram");
    if ([self.delegate respondsToSelector:delegateMethod]) {
        [self.delegate performSelector:delegateMethod];
    }
}
#pragma clang diagnostic pop


@end
