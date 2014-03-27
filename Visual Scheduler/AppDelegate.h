#import <UIKit/UIKit.h>
#import "Repository.h"
#import "SQLiteStore.h"
#import "Database/SharedRepositoryProtocol.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, SharedRepositoryProtocol>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Repository *sharedRepository;

@end
