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

#import "ColorSpectrum.h"

// This is the total number of segments on each axis.
// The spectrum will consists of NUMBER_OF_PARTS^2 rectangles.
// Lower number results in larger rectangles.
#define NUMBER_OF_PARTS 400

#define RGBMax  1.0

@implementation ColorSpectrum

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawSpectrumInRect:rect];
}

/**
 The spectrum is drawn as lines.
 Hue increases down the Y axis. (note: In Cocoa, the Y axis is reversed).
 Saturation increases from left to right, alone the X axis, in quadrants 2 and 3.
 Brightness decreases from left to right, along the X axis, in quadrants 1 and 4.
 */
- (void)drawSpectrumInRect:(CGRect const)rect
{
    __block CGFloat
        hue         = 0,        /* Valid range: [0-RGBMax] */
        saturation  = 0,        /* Valid range: [0-RGBMax] */
        brightness  = RGBMax;   /* Valid range: [0-RGBMax] */
    
    CGFloat const alpha = RGBMax;
    
    CGFloat const
        brightnessChange    = pow(NUMBER_OF_PARTS / 2, -1),
        saturationChange    = brightnessChange,
        hueChange           = pow(NUMBER_OF_PARTS, -1);
    
    /* Draw hue increasing from top to bottom. */
    CGFloat lineY = 0;
    // Overshot RGBMax to prevent a black line at the bottom (Caused by the use of floor())
    while (hue < RGBMax + 2*hueChange)
    {
        CGFloat const lineLength = rect.size.width / NUMBER_OF_PARTS;
        
        /* Block used to avoid duplication of code. */
        const void (^drawLine)(NSUInteger) = ^(NSUInteger currentLine) {
            CGPoint const src = CGPointMake(floor(rect.origin.x + currentLine * lineLength), floor(lineY));
            CGPoint const dest = CGPointMake(ceil(rect.origin.x + (currentLine+1) * lineLength), floor(lineY));
            UIColor * const color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
            [self drawLineWithWidth:ceil(rect.size.height / NUMBER_OF_PARTS) fromPoint:src toPoint:dest usingColor:color];
        };
        
        /* Draw left part of current hue, with saturation increasing from left to right. */
        for (NSUInteger currentLine = 0; currentLine < NUMBER_OF_PARTS / 2; currentLine++) {
            drawLine(currentLine);
            saturation += saturationChange;
        }
        
        /* Draw right part of current hue, with brightness decreasing from left to right. */
        for (NSUInteger currentLine = NUMBER_OF_PARTS / 2; currentLine < NUMBER_OF_PARTS; currentLine++) {
            drawLine(currentLine);
            brightness -= brightnessChange;
        }
        
        /* Configure for next line. */
        brightness = RGBMax;
        saturation = 0;
        hue += hueChange;
        lineY += rect.size.height / NUMBER_OF_PARTS;
    }
}

- (void)drawLineWithWidth:(CGFloat const)width fromPoint:(CGPoint const)source toPoint:(CGPoint const)destination usingColor:(UIColor *)color
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width);
    CGContextMoveToPoint(context, source.x, source.y);
    CGContextAddLineToPoint(context, destination.x, destination.y);
    CGContextStrokePath(context);
}

@end
