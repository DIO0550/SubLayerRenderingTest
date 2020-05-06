//
//  ViewController.m
//  ShadowLayer
//
//  Created by DIO on 2020/05/04.
//  Copyright © 2020 DIO0550. All rights reserved.
//

#import "ViewController.h"
#import "ShadowLayerView.h"

@interface ViewController()

@property (weak) IBOutlet ShadowLayerView *shadowLayerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)createImageButton:(id)sender {
    
    NSBitmapImageRep *btmpImgRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil
                                                                           pixelsWide:NSWidth(self.shadowLayerView.bounds)
                                                                           pixelsHigh:NSHeight(self.shadowLayerView.bounds)
                                                                        bitsPerSample:8.0f
                                                                      samplesPerPixel:4
                                                                             hasAlpha:true
                                                                             isPlanar:false
                                                                       colorSpaceName:NSCalibratedRGBColorSpace
                                                                          bytesPerRow:0
                                                                         bitsPerPixel:32];
    NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep:btmpImgRep];
    [ctx setCompositingOperation:NSCompositingOperationSourceOver];
    CGContextRef cgCtx = ctx.CGContext;
    [self.shadowLayerView.layer.presentationLayer renderInContext:cgCtx];
    CGImageRef cgImage = CGBitmapContextCreateImage(cgCtx);

    self.shadowLayerView.layerUsesCoreImageFilters = YES;
    NSImage *image = [[NSImage alloc] initWithCGImage:cgImage size:self.shadowLayerView.bounds.size];

    NSBitmapImageRep* imageRepresentation = [self.shadowLayerView bitmapImageRepForCachingDisplayInRect:self.shadowLayerView.bounds];
    [self.shadowLayerView cacheDisplayInRect:self.shadowLayerView.bounds toBitmapImageRep:imageRepresentation];
    
    CGImageRef image2 = [self windowImageShot];
    NSImage *img = [[NSImage alloc] initWithCGImage:image2 size:self.view.window.frame.size];
    
}

- (CGImageRef)windowImageShot
{
    CGWindowID windowID = (CGWindowID)[self.view.window windowNumber];
    CGWindowImageOption imageOptions = kCGWindowImageBoundsIgnoreFraming | kCGWindowImageNominalResolution;
    CGWindowListOption singleWindowListOptions = kCGWindowListOptionIncludingWindow;
    CGRect imageBounds = CGRectNull;

    CGImageRef windowImage = CGWindowListCreateImage(imageBounds, singleWindowListOptions, windowID, imageOptions);

    return windowImage;
}

@end
