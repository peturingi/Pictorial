#import "BBANewPictogramViewController.h"
#import "BBAPictogramCreator.h"

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
        [BBAPictogramCreator savePictogramFromUserInputWith:photoTitle.text with:photoView.image];
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

@end
