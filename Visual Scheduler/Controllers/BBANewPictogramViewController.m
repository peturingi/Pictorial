#import "BBANewPictogramViewController.h"
#import "Camera.h"
#import "Pictogram.h"
#import "../../BBACoreDataStack.h"

@interface BBANewPictogramViewController ()
@end

@implementation BBANewPictogramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [photoView setImage:self.photo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)doneButton:(id)sender {
    if ([self verifyTitle]) {
        [self createPictogramFromInput];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self alertUserOfInvalidTitle];
    }
}

- (BOOL)verifyTitle {
    NSString *title = photoTitle.text;
    if (title.length > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)alertUserOfInvalidTitle {
    UIAlertView *invalidTitle = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must specify a title." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [invalidTitle show];
}

- (void)createPictogramFromInput {
    NSString *title = photoTitle.text;
    NSString *location = [self locationOfNewPictogram];
    NSData *imageData = UIImagePNGRepresentation(self.photo);
    [imageData writeToFile:location atomically:YES];
    [[BBACoreDataStack sharedInstance] insertPictogramWithTitle:title andLocation:location];
}

- (NSString *)locationOfNewPictogram {
    NSString *filePrefix = @"pictogram-";
    NSString *uniqueString = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *uniqueFileName = [filePrefix stringByAppendingString:uniqueString];
    uniqueFileName = [uniqueFileName stringByAppendingString:uniqueString];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [dirPaths firstObject];
    
    NSString *uniquePath = [documentsDirectory stringByAppendingPathComponent:uniqueFileName];
    return uniquePath;
}



@end
