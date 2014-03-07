#import "BBAFileManager.h"

@implementation BBAFileManager
+(NSString*)uniqueFileNameWithPrefix:(NSString*)prefix{
    NSString* uniqueString = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString* filename = [prefix stringByAppendingString:uniqueString];
    return [[self documentDirectory] stringByAppendingPathComponent:filename];
}

+(void)saveData:(NSData *)data atLocation:(NSString *)location{
    BOOL success = [data writeToFile:location atomically:YES];
    if(!success){
        [NSException raise:@"Failed to save" format:@"Failed to save the data at the specified location. Location was: %@", location];
    }
}

+(void)saveImage:(UIImage *)image atLocation:(NSString *)location{
    NSData* imageData = UIImagePNGRepresentation(image);
    [[self class] saveData:imageData atLocation:location];
}

+(NSString*)documentDirectory{
    NSArray* directories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL* documentsDir = [directories lastObject];
    return [documentsDir path];
}

@end
