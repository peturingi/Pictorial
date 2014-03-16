#import "BBAFileManager.h"

@implementation BBAFileManager
+(NSString*)uniqueFileNameWithPrefix:(NSString*)prefix{
    NSString* uniqueString = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString* filename = [prefix stringByAppendingString:uniqueString];
    return [[self documentDirectory] stringByAppendingPathComponent:filename];
}

+(NSString*)documentDirectory{
    NSArray* directories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL* documentsDir = [directories lastObject];
    return [documentsDir path];
}

@end
