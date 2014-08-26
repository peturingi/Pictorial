/*
 Copyright (c) 2014, EP Software, Pétur Ingi Egilsson <petur@epsoftware.dk>
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of Pétur Ingi Egilsson nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "UIView+ColorAtPoint.h"

#define RGBMax 255.0f

@implementation UIView (ColorAtPoint)

- (UIColor *)colorAtPoint:(CGPoint)point
{
    NSUInteger const
        width = 1,
        height = 1,
        bitsPerComponent = 8,
        bytesPerRow = 4;
    CGBitmapInfo const bitMapInfo = kCGBitmapAlphaInfoMask && kCGImageAlphaPremultipliedLast;
    
    CGColorSpaceRef const rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    {
    NSAssert(rgbColorSpace != NULL, @"Failed to create color space.");
    } // Assert
    unsigned char rgbData[4] = {0};
    CGContextRef const context = CGBitmapContextCreate(rgbData, width, height, bitsPerComponent, bytesPerRow, rgbColorSpace, bitMapInfo);
    {
        NSAssert(context, @"Failed to create bitmap context.");
    } // Assert
    CGContextTranslateCTM(context, -point.x, -point.y);
    [self.layer renderInContext:context];
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    CGFloat const
        red     = rgbData[0] / RGBMax,
        green   = rgbData[1] / RGBMax,
        blue    = rgbData[2] / RGBMax,
        alpha   = rgbData[3] / RGBMax;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
