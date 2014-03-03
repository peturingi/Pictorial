//
//  BBAManagedObjectModel.h
//  TestCoreData
//
//  Created by Brian Pedersen on 01/03/14.
//  Copyright (c) 2014 TestOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BBAModel : NSObject{
    NSManagedObjectModel* _managedObjectModel;
}

+(instancetype)modelFromModelNamed:(NSString*)modelName;
-(NSManagedObjectModel*)managedObjectModel;

@end
