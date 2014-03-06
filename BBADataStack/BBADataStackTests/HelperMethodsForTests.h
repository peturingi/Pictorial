//
//  HelperMethodsForTests.h
//  TestCoreData
//
//  Created by Brian Pedersen on 02/03/14.
//  Copyright (c) 2014 TestOrg. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const kBBATestModel = @"TestModel";

@interface HelperMethodsForTests : NSObject

+(NSURL*)URLForStorefileNamed:(NSString*)storeName;
+(NSString*)storefileNameForTest:(id)testClass andMethodName:(NSString*)methodName;

@end
