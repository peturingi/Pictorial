#import "PictogramCreator.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@implementation PictogramCreator

- (id)init {
    NSAssert(false, @"Do not use this initializer.");
    return nil;
}

- (id)initWithTitle:(NSString *)aString image:(NSData *)imageData {
    self = [super init];
    if (self) {
        _imageData = imageData;
        _title = aString;
    }
    NSAssert(self, @"Super failed to init.");
    return self;
}

- (BOOL)compute {
    NSManagedObjectContext *managedObjectContext = [self appDelegate].managedObjectContext;
    
    BOOL pictogramCreated = [self createPictogram:managedObjectContext];
    BOOL pictogramSaved = [self save:managedObjectContext];
    
    if (pictogramCreated && pictogramSaved) return YES;
    else return NO;
}

- (AppDelegate *)appDelegate {
    return [[UIApplication sharedApplication] delegate];
}

- (BOOL)createPictogram:(NSManagedObjectContext *)context {
    NSAssert(_imageData, @"Must not be nil.");
    NSAssert(_title, @"Must not be nil.");
    
    @try {
        NSManagedObject *pictogram = [NSEntityDescription insertNewObjectForEntityForName:CD_ENTITY_PICTOGRAM inManagedObjectContext:context];
        [pictogram setValue:_title forKey:CD_KEY_PICTOGRAM_TITLE];
        [pictogram setValue:_imageData forKey:CD_KEY_PICTOGRAM_IMAGE];
    }
    @catch (NSException *e) { return NO; }
    
    return YES;
}

- (BOOL)save:(const NSManagedObjectContext *)context {
    return [context save:nil] ? YES : NO;
}

@end
