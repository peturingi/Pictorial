//
//  EditPictogramViewController.m
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 24/08/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import "EditPictogramViewController.h"

@interface EditPictogramViewController ()
    @property (weak, nonatomic) IBOutlet UIImageView *image;
    @property (weak, nonatomic) IBOutlet UITextField *pictogramTitle;
@end

@implementation EditPictogramViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    {
        NSAssert(self.pictogram, @"Pictogram has not been set.");
    }
    self.pictogramTitle.text = self.pictogram.title;
    self.image.image = self.pictogram.uiImage;
}
- (IBAction)pressedDone:(id)sender {
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

- (void)alertUserOfInvalidTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must specify a title." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


@end
