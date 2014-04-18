//
//  SettingsManager.h
//  Visual Scheduler
//
//  Created by Brian Pedersen on 17/04/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SettingsManager : NSObject {
    sqlite3* _databaseConnection;
}

-(void)setIntegerValue:(NSInteger)value forKey:(NSString*)key;
-(NSInteger)integerValueForKey:(NSString*)key;

-(void)setStringValue:(NSString*)value forKey:(NSString*)key;
-(NSString*)stringValueForKey:(NSString*)key;

-(void)setNumber:(NSNumber*)number forKey:(NSString*)key;
-(NSNumber*)numberForKey:(NSString*)key;
@end
