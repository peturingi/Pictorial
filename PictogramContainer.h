#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PictogramContainer : NSManagedObject

@property (nonatomic, retain) NSManagedObject *pictogram;
@property (nonatomic, retain) NSManagedObject *schedule;

@end
