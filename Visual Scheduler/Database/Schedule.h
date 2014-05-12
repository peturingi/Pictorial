#import <Foundation/Foundation.h>
#import "../Protocols/ImplementsCount.h"
#import "../Protocols/ImplementsObjectAtIndex.h"
#import "Pictogram.h"
@class Repository;
@interface Schedule : NSObject <ImplementsCount, ImplementsObjectAtIndex>{
    NSMutableArray* _pictograms;
    Repository* _repo;
}
@property (readonly) NSInteger uniqueIdentifier;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIColor *color;
- (id)initWithTitle:(NSString *)title withColor:(UIColor *)color withUniqueIdentifier:(NSInteger)identifier;
- (NSArray *)pictograms;
- (NSInteger)count;
-(void)addPictogram:(Pictogram*)pictogram atIndex:(NSInteger)index;
-(void)removePictogramAtIndex:(NSInteger)index;
-(void)exchangePictogramsAtIndex:(NSInteger)indexOne andIndex:(NSInteger)indexTwo;
-(void)addPictogram:(Pictogram*)pictogram;
+ (NSArray *)allSchedules;
@end
