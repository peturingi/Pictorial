#import "HelperMethodsForTests.h"

static NSString* const kBBAStoreFileExt = @".sqlite";

@implementation HelperMethodsForTests

+(NSURL*)URLForStorefileNamed:(NSString*)storeName{
    NSURL* documentsDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsDir URLByAppendingPathComponent:storeName];
}

+(NSString*)storefileNameForTest:(id)testClass andMethodName:(NSString*)methodName{
    NSString* className = NSStringFromClass([testClass class]);
    return [[className stringByAppendingString:methodName] stringByAppendingString:kBBAStoreFileExt];
}

@end
