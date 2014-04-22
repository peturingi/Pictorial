#import "CreatePictogram.h"
#import "Repository.h"
#import "Pictogram.h"

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
    [self createPictogram];
}

- (void)createPictogram {
    NSAssert(self.photoView.image != nil, @"Cannot create a pictogram without a photo.");
    NSAssert(self.photoTitle.text.length > 0, @"Cannot create a pictogram without a title.");
    
    if ([self validInputTitle]) {
        id createdPictogram = [[Repository defaultRepository] pictogramWithTitle:self.photoTitle.text withImage:self.photoView.image];
        if (!createdPictogram) {
            [self throwErrorCreatingPictogram];
        }
        
        [self dismissViewController];
    }
    else {
        [self alertUserOfInvalidTitle];
    }
}

- (BOOL)validInputTitle {
    return ([self.photoTitle.text length] > 0) ? YES : NO;
}

#pragma mark -

- (void)alertUserOfInvalidTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must specify a title." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)throwErrorCreatingPictogram {
    NSDictionary *userInfo = @{TITLE_KEY : self.photoTitle.text,
                              IMAGE_KEY : self.photoView.image};
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Expected to receive a pictogram." userInfo:userInfo];

}

@end