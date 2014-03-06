//
//  Pictogram+CDStack.h
//  BBAModel
//
//  Created by Brian Pedersen on 05/03/14.
//  Copyright (c) 2014 BBA. All rights reserved.
//

#import "Pictogram.h"
#import "ModelProtocol.h"

@class UIImage;
@interface Pictogram (CDStack) <ModelProtocol>

+(void)insertWithTitle:(NSString*)title andImage:(UIImage*)image;
@end
