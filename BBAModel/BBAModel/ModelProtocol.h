//
//  ModelProtocol.h
//  BBAModel
//
//  Created by Brian Pedersen on 05/03/14.
//  Copyright (c) 2014 BBA. All rights reserved.
//

#import "../../BBAServiceProvider/BBAServiceProvider/BBAServiceProvider.h"
#import "../../BBADataStack/BBADataStack/BBADataStack.h"
#import "../../BBAFileManager/BBAFileManager/BBAFileManager.h"

@protocol ModelProtocol
+(NSFetchedResultsController*)fetchedResultsController;
@end
