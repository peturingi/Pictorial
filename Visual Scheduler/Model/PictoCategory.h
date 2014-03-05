#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pictogram;

@interface PictoCategory : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *pictogram;
@end

@interface PictoCategory (CoreDataGeneratedAccessors)

- (void)addPictogramObject:(Pictogram *)value;
- (void)removePictogramObject:(Pictogram *)value;
- (void)addPictogram:(NSSet *)values;
- (void)removePictogram:(NSSet *)values;

@end
