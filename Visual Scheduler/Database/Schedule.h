#import <Foundation/Foundation.h>
#import "../Protocols/ImplementsCount.h"
#import "../Protocols/ImplementsObjectAtIndex.h"

@interface Schedule : NSObject <ImplementsCount, ImplementsObjectAtIndex>
@property (readonly) NSInteger uniqueIdentifier;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIColor *color;
- (id)initWithTitle:(NSString *)title withColor:(UIColor *)color withUniqueIdentifier:(NSInteger)identifier;

- (void)setPictograms:(NSArray *)pictograms;
- (NSArray *)pictograms;
- (NSInteger)count;

@end
