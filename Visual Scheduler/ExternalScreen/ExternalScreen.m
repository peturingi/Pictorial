#include "WeekCollectionViewLayout.h"
#include "CalendarCollectionViewController.h"
#import "ExternalScreen.h"
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

-(void)screenDidConnectNotification:(NSNotification*)notification{
    UIScreen* screen = [notification object];
    NSLog(@"screen did connect");
    [self prepareScreen:screen];
}

-(void)screenDidDisconnectNotification:(NSNotification*)notification{
    NSLog(@"screen did disconnect");
    if(_window){
        _window.hidden = YES;
        _window = nil;
    }
}

-(void)connectScreenIfAvailable{
    if([[UIScreen screens]count] > 1){
        NSLog(@"connection to initial available screen");
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
    _window.hidden = NO;
}

-(UIViewController*)destinationViewController{
    WeekCollectionViewLayout *layout = [[WeekCollectionViewLayout alloc] init];
    CalendarCollectionViewController *vc = [[CalendarCollectionViewController alloc] initWithCollectionViewLayout:layout];
    return vc;
}
@end
