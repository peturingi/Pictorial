#import "UIBarButtonItem+EditButton.h"
#import <objc/runtime.h>
static char const * const kTruthValue = "truthValue";

@implementation UIBarButtonItem (EditButton)

- (void)setEditMode:(BOOL)truthValue
{
    NSNumber *number = [NSNumber numberWithBool:truthValue];
    objc_setAssociatedObject(self, kTruthValue, number , OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)editMode
{
    NSNumber *number = objc_getAssociatedObject(self, kTruthValue);
    return [number boolValue];
}

@end
