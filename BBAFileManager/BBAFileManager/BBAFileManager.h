#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BBAFileManager : NSObject
+(NSString*)uniqueFileNameWithPrefix:(NSString*)prefix;
+(void)saveImage:(UIImage*)image atLocation:(NSString*)location;
@end
