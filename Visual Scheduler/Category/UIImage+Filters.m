#import "UIImage+Filters.h"
@implementation UIImage (Filters)
-(UIImage*)applyPhotoEffectMono{
    CIImage* inputImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter* photoEffectMono = [CIFilter filterWithName:@"CIPhotoEffectMono"];
    [photoEffectMono setValue:inputImage forKey:@"inputImage"];
    return [self processCIImage:inputImage forFilter:photoEffectMono];
}

-(UIImage*)applyPhotoEffectNoir{
    CIImage* inputImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter* photoEffectNoir = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
    [photoEffectNoir setValue:inputImage forKey:@"inputImage"];
    return [self processCIImage:inputImage forFilter:photoEffectNoir];
}
-(UIImage*)processCIImage:(CIImage*)ciImage forFilter:(CIFilter*)filter{
    CIImage* outputImage = [filter outputImage];
    CGRect extent = ciImage.extent;
    CGImageRef processedCGImage = [[CIContext contextWithOptions:nil] createCGImage:outputImage fromRect:extent];
    UIImage* image = [UIImage imageWithCGImage:processedCGImage];
    CGImageRelease(processedCGImage);
    return image;
}
@end
