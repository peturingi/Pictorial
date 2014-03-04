#import "BBANewPictogramViewController.h"
#import "Camera.h"

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

- (void)createPictogramFromInput {
    
}

- (void)alertUserOfInvalidTitle {
    UIAlertView *invalidTitle = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must specify a title." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [invalidTitle show];
}

@end
