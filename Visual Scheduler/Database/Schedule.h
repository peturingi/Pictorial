#import <Foundation/Foundation.h>

@interface Schedule : NSObject
@property (readonly) NSInteger uniqueIdentifier;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) NSArray *pictograms;
- (id)initWithTitle:(NSString *)title withColor:(UIColor *)color withUniqueIdentifier:(NSInteger)identifier;
- (NSUInteger)numberOfPictograms;
@end
