#import <Foundation/Foundation.h>

@protocol ContainsImageData <NSObject>

@required
@property (nonatomic, retain) NSData *image;

@end
