#import "EditPictogramViewController.h"
#import "Pictogram.h"

@interface EditPictogramViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *pictogramTitle;

@end

@implementation EditPictogramViewController

- (void)viewWillAppear:(BOOL)animated
{
    NSAssert(self.pictogram, @"Pictogram has not been set.");

    self.pictogramTitle.text = self.pictogram.title;
    self.image.image = self.pictogram.uiImage;
}

- (IBAction)pressedDone:(id)sender
{
    if ([self validInputTitle]) {
        [self save];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self alertUserOfInvalidTitle];
    }
}

- (IBAction)pressedCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)save
{
    self.pictogram.title = self.pictogramTitle.text;
    [[self.pictogram managedObjectContext] save:nil];
}

- (BOOL)validInputTitle {
    return ([self.pictogramTitle.text length] > 0) ? YES : NO;
}

#pragma mark -

- (void)alertUserOfInvalidTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must specify a title." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
