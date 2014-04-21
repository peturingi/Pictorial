#import <UIKit/UIKit.h>
@class ExternalScreen;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    ExternalScreen* _externalScreen;
}
@property (strong, nonatomic) UIWindow *window;
@end
