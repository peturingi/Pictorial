#import <Foundation/Foundation.h>
@class  NSManagedObjectID;

@protocol AddPictogramWithID <NSObject>

- (BOOL)addPictogramWithID:(NSManagedObjectID *)_idOfPictogramBeingMoved atPoint:(CGPoint)location relativeToView:(UIView *)view;

@end
