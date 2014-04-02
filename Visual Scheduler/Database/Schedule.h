#import <Foundation/Foundation.h>

@interface Schedule : NSObject
@property (readonly) NSInteger uniqueIdentifier;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIColor *color;
- (id)initWithTitle:(NSString *)title withColor:(UIColor *)color withUniqueIdentifier:(NSInteger)identifier;

- (void)setPictograms:(NSArray *)pictograms;
- (NSArray *)pictograms;

@end
