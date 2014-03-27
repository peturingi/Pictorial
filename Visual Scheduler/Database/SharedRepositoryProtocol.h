#import <Foundation/Foundation.h>
#import "Repository.h"
@protocol SharedRepositoryProtocol <NSObject>
@required
- (Repository *)sharedRepository;
@end
