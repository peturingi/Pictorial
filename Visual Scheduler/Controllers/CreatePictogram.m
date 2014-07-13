#import "AppDelegate.h"
#import "CreatePictogram.h"
#import <CoreData/CoreData.h>

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
        const AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
        NSManagedObject *pictogram = [NSEntityDescription insertNewObjectForEntityForName:CD_ENTITY_PICTOGRAM inManagedObjectContext:managedObjectContext];
        [pictogram setValue:self.photoTitle.text forKey:CD_KEY_PICTOGRAM_TITLE];
        NSData *imageData = UIImagePNGRepresentation(self.photoView.image);
        [pictogram setValue:imageData forKey:CD_KEY_PICTOGRAM_IMAGE];
        
        // Save the new pictogram
        NSError *saveError;
        [managedObjectContext save:&saveError];
        if (saveError) {
            @throw [NSException exceptionWithName:saveError.localizedDescription reason:saveError.localizedFailureReason userInfo:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:PictogramCreatedNotification object:nil];
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

@end