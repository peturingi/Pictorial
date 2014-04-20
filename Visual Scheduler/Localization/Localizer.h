//
//  LocalizationManager.h
//  Visual Scheduler
//
//  Created by Brian Pedersen on 19/04/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLiteDatabaseConnection.h"

@interface Localizer : NSObject{
    NSString* _localeIdentifier;
    SQLiteDatabaseConnection* _dbcon;
    BOOL _localeExists;
}
+(instancetype)defaultLocalizer;
-(id)initLocalizerForLocale:(NSString*)localeString;
-(NSString*)localizeString:(NSString*)string;
@end
