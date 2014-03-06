//
//  Schedule+CDStack.h
//  BBAModel
//
//  Created by Brian Pedersen on 04/03/14.
//  Copyright (c) 2014 BBA. All rights reserved.
//

#import "Schedule.h"
#import "ModelProtocol.h"

@interface Schedule (CDStack) <ModelProtocol>
+(void)insertWithTile:(NSString*)title imageLogo:(UIImage*)image andBackgroundColor:(NSUInteger)colorIndex;
@end