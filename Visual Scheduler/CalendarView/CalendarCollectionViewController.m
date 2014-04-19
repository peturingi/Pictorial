#import "CalendarCollectionViewController.h"

#import "NowCollectionViewLayout.h"
#import "TodayCollectionViewLayout.h"
#import "WeekCollectionViewLayout.h"

@implementation CalendarCollectionViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self){
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCalendarViewMode:) name:NOTIFICATION_CALENDAR_VIEW object:nil];
    }
    
    return self;
}

- (void)handleCalendarViewMode:(NSNotification *)notification {
    if ([notification.name isEqualToString:NOTIFICATION_CALENDAR_VIEW]) {
        NSNumber *viewMode = [notification object];
        UICollectionViewLayout *layout;

        switch (viewMode.integerValue) {
            case 0:
                layout = [[NowCollectionViewLayout alloc] initWithCoder:nil];
                break;
                
            case 1:
                layout = [[TodayCollectionViewLayout alloc] initWithCoder:nil];
                break;
                
            case 2:
                layout = [[WeekCollectionViewLayout alloc] initWithCoder:nil];
                break;
        }
        
        [layout prepareForTransitionFromLayout:self.collectionView.collectionViewLayout];
        [self.collectionViewLayout prepareForTransitionToLayout:layout];
        
        [self.collectionView setCollectionViewLayout:layout animated:YES];
    }
}

@end
