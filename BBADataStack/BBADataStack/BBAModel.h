#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BBAModel : NSObject{
    NSManagedObjectModel* _managedObjectModel;
}

+(instancetype)mergedBundleModel;
+(instancetype)modelFromModelNamed:(NSString*)modelName;
-(NSManagedObjectModel*)managedObjectModel;

@end