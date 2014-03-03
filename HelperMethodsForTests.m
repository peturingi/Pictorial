//
//  HelperMethodsForTests.m
//  TestCoreData
//
//  Created by Brian Pedersen on 02/03/14.
//  Copyright (c) 2014 TestOrg. All rights reserved.
//

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
