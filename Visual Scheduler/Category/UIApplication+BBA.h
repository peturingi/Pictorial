#import <UIKit/UIKit.h>

@interface UIApplication (BBA)
- (NSString *)documentDirectory;
- (NSString *)uniqueFileNameWithPrefix:(NSString*)prefix;
@end
