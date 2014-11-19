//
//  MJPPdfView.m
//  SentencingGuidelines
//
//  Created by Mike Platt on 31/10/2014.
//  Copyright (c) 2014 Ambay Software Ltd. All rights reserved.
//

#import "MJPPdfView.h"
#import "MJPPdfTiledView.h"
#import <QuartzCore/QuartzCore.h>

@interface MJPPdfView ()

@property (assign, nonatomic) CGFloat scale;
@property (strong, nonatomic) UIImage *pageImage;
@property (strong, nonatomic) CALayer *imageLayer;
@property (strong, nonatomic) MJPPdfTiledView *tiledLayer;

@end

@implementation MJPPdfView

@synthesize pdfPage = _pdfPage;

- (id)initWithFrame:(CGRect)frame andScale:(CGFloat)scale {
    self = [super initWithFrame:frame];
    if (self) {
        
        _scale = scale;
        
        _imageLayer = [CALayer new];
        _imageLayer.frame = self.bounds;
        [self.layer addSublayer:_imageLayer];
    }
    return self;
}

- (void)drawImageFromPage {
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    
        CGFloat scale = [UIScreen mainScreen].scale;
        CGRect frame = CGRectMake(0.0, 0.0, self.frame.size.width * scale, self.frame.size.height * scale);
        UIGraphicsBeginImageContext(frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
        CGContextFillRect(context, frame);
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0.0, frame.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGContextScaleCTM(context, _scale * scale, _scale * scale);
        CGContextDrawPDFPage(context, self.pdfPage);
        CGContextRestoreGState(context);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.imageLayer.contents = (__bridge id)(image.CGImage);
        });
    });
}

- (void)dealloc {
    if(self.pdfPage != NULL) {
        CGPDFPageRelease(self.pdfPage);
    }
    [_imageLayer removeFromSuperlayer];
}

- (void)drawTiledPDFPageAtScale:(CGFloat)scale {
    if(!_tiledLayer) {
        _tiledLayer = [[MJPPdfTiledView alloc] initWithFrame:self.bounds page:self.pdfPage scale:scale];
        [self addSubview:_tiledLayer];
    }
}

- (void)removeTiledPDFPage {
    [_tiledLayer removeFromSuperview];
    _tiledLayer = nil;
}

#pragma mark - Setters

- (void)setPdfPage:(CGPDFPageRef)pdfPage {
    if(_pdfPage != NULL) {
        CGPDFPageRelease(self.pdfPage);
    }
    if(pdfPage != NULL) {
        _pdfPage = CGPDFPageRetain(pdfPage);
        [self drawImageFromPage];
    }
}

@end
