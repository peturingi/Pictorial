#import "PictogramCreator.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@implementation PictogramCreator

- (id)init
{
    NSAssert(false, @"Do not use this initializer.");
    return nil;
}

- (id)initWithTitle:(NSString * const)aString image:(NSData * const)imageData
{
    self = [super init];
    if (self) {
        _imageData = imageData;
        _title = aString;
    }
    NSAssert(self, @"Super failed to init.");
    return self;
}

- (BOOL)compute
{
    NSManagedObjectContext * const managedObjectContext = [self appDelegate].managedObjectContext;
    
    BOOL const pictogramCreated = [self createPictogram:managedObjectContext];
    BOOL const pictogramSaved = [self save:managedObjectContext];
    
    if (pictogramCreated && pictogramSaved) return YES;
    else return NO;
}

- (AppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

- (BOOL)createPictogram:(NSManagedObjectContext * const)context
{
    NSAssert(_imageData, @"Must not be nil.");
    NSAssert(_title, @"Must not be nil.");
    
    @try {
        NSManagedObject * const pictogram = [NSEntityDescription insertNewObjectForEntityForName:CD_ENTITY_PICTOGRAM inManagedObjectContext:context];
        [pictogram setValue:_title forKey:CD_KEY_PICTOGRAM_TITLE];
        [pictogram setValue:_imageData forKey:CD_KEY_PICTOGRAM_IMAGE];
    }
    @catch (NSException *e) { return NO; }
    
    return YES;
}

- (BOOL)save:(NSManagedObjectContext * const)context
{
    return [context save:nil] ? YES : NO;
}

@end
