#import "AppDelegate.h"
#import "CreatePictogram.h"
#import <CoreData/CoreData.h>
#import "PictogramCreator.h"

@implementation CreatePictogram

- (void)viewWillAppear:(BOOL)animated {
    NSAssert(self.photo, @"Missing photo.");
    
    [self.photoView setImage:self.photo];
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewController];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButton:(id)sender {
    NSAssert(self.photoView.image != nil, @"Cannot create a pictogram without a photo.");
    NSAssert(self.photoTitle.text.length > 0, @"Cannot create a pictogram without a title.");
    
    if ([self validInputTitle]) {
        [self createPictogram];
        [self dismissViewController];
    } else {
        [self alertUserOfInvalidTitle];
    }
}

- (void)createPictogram {
    const PictogramCreator *pictogramCreator = [[PictogramCreator alloc] initWithTitle:self.photoTitle.text image:UIImagePNGRepresentation(self.photoView.image)];
    [pictogramCreator compute];
}

- (BOOL)validInputTitle {
    return ([self.photoTitle.text length] > 0) ? YES : NO;
}

#pragma mark -

- (void)alertUserOfInvalidTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must specify a title." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end