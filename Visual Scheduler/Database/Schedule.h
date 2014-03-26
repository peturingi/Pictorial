#import <Foundation/Foundation.h>

@interface Schedule : NSObject
@property NSInteger uniqueIdentifier;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) NSArray *pictograms;
@end
