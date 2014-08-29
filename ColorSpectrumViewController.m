#import "ColorSpectrumViewController.h"
#import "UIView+ColorAtPoint.h"
#import "ColorView.h"

/* to get schedule and set colors */
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Schedule.h"

@interface ColorSpectrumViewController ()

@property (weak, nonatomic) IBOutlet ColorView *monday;
@property (weak, nonatomic) IBOutlet ColorView *tuesday;
@property (weak, nonatomic) IBOutlet ColorView *wednesday;
@property (weak, nonatomic) IBOutlet ColorView *thursday;
@property (weak, nonatomic) IBOutlet ColorView *friday;
@property (weak, nonatomic) IBOutlet ColorView *saturday;
@property (weak, nonatomic) IBOutlet ColorView *sunday;

@property (weak, nonatomic) IBOutlet UILabel *mondayLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *wednesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *thursdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *fridayLabel;
@property (weak, nonatomic) IBOutlet UILabel *saturdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *sundayLabel;

@property (weak, nonatomic) ColorView *selectedDay;
@end

@implementation ColorSpectrumViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self setupColorViews];
    [self setupLabelViews];
}

- (void)setupColorViews {
    NSOrderedSet *days = [Schedule schedules];
    self.monday.color       = ((Schedule*)days[0]).backgroundColor;
    self.tuesday.color      = ((Schedule*)days[1]).backgroundColor;
    self.wednesday.color    = ((Schedule*)days[2]).backgroundColor;
    self.thursday.color     = ((Schedule*)days[3]).backgroundColor;
    self.friday.color       = ((Schedule*)days[4]).backgroundColor;
    self.saturday.color     = ((Schedule*)days[5]).backgroundColor;
    self.sunday.color       = ((Schedule*)days[6]).backgroundColor;
}

- (void)setupLabelViews {
    NSOrderedSet *days = [Schedule schedules];
    self.mondayLabel.text   = ((Schedule*)days[0]).title;
    self.tuesdayLabel.text  = ((Schedule*)days[1]).title;
    self.wednesdayLabel.text= ((Schedule*)days[2]).title;
    self.thursdayLabel.text = ((Schedule*)days[3]).title;
    self.fridayLabel.text   = ((Schedule*)days[4]).title;
    self.saturdayLabel.text = ((Schedule*)days[5]).title;
    self.sundayLabel.text   = ((Schedule*)days[6]).title;
}

- (IBAction)daySelected:(UITapGestureRecognizer * const)sender {
    self.selectedDay = (ColorView*)sender.view;
}
- (IBAction)colorSelected:(id)sender {
    UIGestureRecognizer *gr = sender;
    if (gr.state == UIGestureRecognizerStateBegan ||
        gr.state == UIGestureRecognizerStateChanged )
    {
        /* Prevent the gesture recognizer from moving out of the view. */
        CGPoint point = [gr locationInView:gr.view];
        CGSize const size = gr.view.bounds.size;
        if (point.x < 0) point.x = 0;
        if (point.y < 0) point.y = 0;
        if (point.x > size.width)  point.x = size.width;
        if (point.y > size.height) point.y = size.height-1; // TODO: Black color if -1 is omitted. I dont know why.
        
        self.selectedDay.color = [gr.view colorAtPoint:point];
    }
}

/* Done button pressed. */
- (IBAction)save{
    [self applyColors];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.managedObjectContext save:nil]; // TODO: handle errors.
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)applyColors {
    NSOrderedSet *days = [Schedule schedules];
    ((Schedule*)days[0]).backgroundColor = self.monday.color;
    ((Schedule*)days[1]).backgroundColor = self.tuesday.color;
    ((Schedule*)days[2]).backgroundColor = self.wednesday.color;
    ((Schedule*)days[3]).backgroundColor = self.thursday.color;
    ((Schedule*)days[4]).backgroundColor = self.friday.color;
    ((Schedule*)days[5]).backgroundColor = self.saturday.color;
    ((Schedule*)days[6]).backgroundColor = self.sunday.color;
}

@end
