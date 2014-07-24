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
    const AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if ([self createPictogram:appDelegate.managedObjectContext] && [self save:appDelegate.managedObjectContext]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)createPictogram:(NSManagedObjectContext *)context {
    NSAssert(_imageData, @"Must not be nil.");
    NSAssert(_title, @"Must not be nil.");
    
    BOOL successful = YES;
    
    @try {
        NSManagedObject *pictogram = [NSEntityDescription insertNewObjectForEntityForName:CD_ENTITY_PICTOGRAM inManagedObjectContext:context];
        [pictogram setValue:_title forKey:CD_KEY_PICTOGRAM_TITLE];
        [pictogram setValue:_imageData forKey:CD_KEY_PICTOGRAM_IMAGE];
    }
    @catch (NSException *e) {
        successful = NO;
    }
    
    if (successful) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)save:(const NSManagedObjectContext *)context {
    NSError *error;
    if ([context save:&error]) {
        return YES;
    } else {
        return NO;
    }
}

@end