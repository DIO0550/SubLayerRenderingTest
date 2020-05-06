//
//  ShadowLayerView.m
//  ShadowLayer
//
//  Created by DIO on 2020/05/05.
//  Copyright © 2020 DIO0550. All rights reserved.
//

@import Quartz;

#import "ShadowLayerView.h"
@implementation NSBezierPath (BezierPathQuartzUtilities)
// This method works only in OS X v10.2 and later.
- (CGPathRef)quartzPath
{
    int i, numElements;

    // Need to begin a path here.
    CGPathRef           immutablePath = NULL;

    // Then draw the path elements.
    numElements = [self elementCount];
    if (numElements > 0)
    {
        CGMutablePathRef    path = CGPathCreateMutable();
        NSPoint             points[3];
        BOOL                didClosePath = YES;

        for (i = 0; i < numElements; i++)
        {
            switch ([self elementAtIndex:i associatedPoints:points])
            {
                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                    break;

                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                    didClosePath = NO;
                    break;

                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
                                        points[1].x, points[1].y,
                                        points[2].x, points[2].y);
                    didClosePath = NO;
                    break;

                case NSClosePathBezierPathElement:
                    CGPathCloseSubpath(path);
                    didClosePath = YES;
                    break;
            }
        }

        // Be sure the path is closed or Quartz may not do valid hit detection.
        if (!didClosePath)
            CGPathCloseSubpath(path);

        immutablePath = CGPathCreateCopy(path);
        CGPathRelease(path);
    }

    return immutablePath;
}
@end


@implementation ShadowLayerView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addShadowLayer];
}

- (void)addShadowLayer {
    self.wantsLayer = YES;
    
    CAShapeLayer *shadowLayer = [[CAShapeLayer alloc] init];
    
    [self.layer addSublayer:shadowLayer];
    
    NSRect rect = NSMakeRect(self.bounds.size.width / 4.0f,
                             self.bounds.size.height / 4.0f,
                             self.bounds.size.width / 2.0f,
                             self.bounds.size.height / 2.0f);
    
    shadowLayer.frame = self.bounds;
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:rect];
    shadowLayer.masksToBounds = YES;
    shadowLayer.shadowPath = [path quartzPath];
    shadowLayer.shadowColor = [NSColor.yellowColor CGColor];
    shadowLayer.shadowRadius = 20.0f;
    self.layer.backgroundColor = [[NSColor blueColor] CGColor];
    shadowLayer.shadowOffset = NSMakeSize(0.0f, 0.0f);
    shadowLayer.shadowOpacity = 1.0f;
    //shadowLayer.path = [path quartzPath];
    //shadowLayer.fillColor = NSColor.clearColor.CGColor;
}
@end

