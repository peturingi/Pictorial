#import <Foundation/Foundation.h>

static NSString* const kBBATestModel = @"TestModel";

@interface HelperMethodsForTests : NSObject

+(NSURL*)URLForStorefileNamed:(NSString*)storeName;
+(NSString*)storefileNameForTest:(id)testClass andMethodName:(NSString*)methodName;

@end
