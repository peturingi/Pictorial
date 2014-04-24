#import "ExternalScreen.h"
#import "ExternalViewController.h"
#import "ExternalViewLayout.h"
#import "DayCollectionViewController.h"
#import "WeekCollectionViewLayout.h"

@implementation ExternalScreen
-(id)init{
    self = [super init];
    if(self){
        [self connectScreenIfAvailable];
        [self registerForNotifications];
    }
    return self;
}

-(void)registerForNotifications{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(screenDidConnectNotification:) name:UIScreenDidConnectNotification object:nil];
    [nc addObserver:self selector:@selector(screenDidDisconnectNotification:) name:UIScreenDidDisconnectNotification object:nil];
}

-(void)dealloc{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

-(void)screenDidConnectNotification:(NSNotification*)notification{
    UIScreen* screen = [notification object];
    [self prepareScreen:screen];
}

-(void)screenDidDisconnectNotification:(NSNotification*)notification{
    if(_window){
        _window.hidden = YES;
        _window = nil;
    }
}

-(void)connectScreenIfAvailable{
    NSUInteger count = [[UIScreen screens]count];
    if(count > 1){
        [self prepareScreen:[[UIScreen screens]lastObject]];
    }
}

-(void)prepareScreen:(UIScreen*)screen{
    if(_window){
        return;
    }
    CGRect screenBounds = screen.bounds;
    _window = [[UIWindow alloc] initWithFrame:screenBounds];
    _window.screen = screen;
    _window.rootViewController = [self destinationViewController];
    [_window makeKeyAndVisible];
    _window.hidden = NO;
}

-(UIViewController*)destinationViewController{
    UICollectionViewLayout* layout = [[WeekCollectionViewLayout alloc]init];
    UIViewController* vs = [[DayCollectionViewController alloc]initWithCollectionViewLayout:layout];
    return vs;
}
@end
