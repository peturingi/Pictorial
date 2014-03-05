#import <UIKit/UIKit.h>
#import "AudioRecorderDelegate.h"

@interface ViewController : UIViewController <AudioRecorderDelegate>
@property (weak, nonatomic) IBOutlet UIButton *play;
@property (weak, nonatomic) IBOutlet UIButton *stop;
@property (weak, nonatomic) IBOutlet UIButton *record;

@end
