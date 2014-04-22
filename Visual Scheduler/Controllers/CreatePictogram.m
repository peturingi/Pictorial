#import "CreatePictogram.h"
#import "../Database/Pictogram.h"
#import "../Database/Repository.h"

@interface CreatePictogram ()
@end

@implementation CreatePictogram

- (void)viewWillAppear:(BOOL)animated {
    [self.photoView setImage:self.photo];
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewController];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButton:(id)sender {
    [self createPictogram];
}

- (void)createPictogram {
    NSAssert(self.photoView.image != nil, @"Invalid photo");
    NSAssert(self.photoTitle.text.length > 0, @"Photo must have a title.");
    
    if ([self verifyTitle]) {
        [[Repository defaultRepository] pictogramWithTitle:self.photoTitle.text withImage:self.photoView.image];
        [self dismissViewController];
    } else {
        [self alertUserOfInvalidTitle];
    }
}

- (BOOL)verifyTitle {
    return ([self.photoTitle.text length] > 0) ? YES : NO;
}

- (void)alertUserOfInvalidTitle {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You must specify a title." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
