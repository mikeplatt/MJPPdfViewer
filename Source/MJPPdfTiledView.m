//
//  MJPPdfTiledView.m
//  SentencingGuidelines
//
//  Created by Mike Platt on 31/10/2014.
//  Copyright (c) 2014 Ambay Software Ltd. All rights reserved.
//

#import "MJPPdfTiledView.h"
#import <QuartzCore/QuartzCore.h>

@interface MJPPdfTiledView ()

@property (nonatomic, assign) CGFloat scale;

@end

@implementation MJPPdfTiledView

@synthesize pdfPage = _pdfPage;

- (id)initWithFrame:(CGRect)frame andScale:(CGFloat)scale {
    self = [super initWithFrame:frame];
    if (self) {
        CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
        tiledLayer.levelsOfDetail = 4;
        tiledLayer.levelsOfDetailBias = 3;
        tiledLayer.tileSize = CGSizeMake(512.0, 512.0);
        _scale = scale;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 0.5;
    }
    return self;
}

+ (Class)layerClass {
    return [CATiledLayer class];
}

-(void)drawLayer:(CALayer*)layer inContext:(CGContextRef)context {
    
    CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
    CGContextFillRect(context, self.bounds);
 
    if(_pdfPage == NULL) {
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextScaleCTM(context, _scale, _scale);
    //NSLog(@"%f, layer.bounds=%@", _scale, NSStringFromCGRect(self.layer.bounds));
    CGContextDrawPDFPage(context, self.pdfPage);
    CGContextRestoreGState(context);
}

- (void)dealloc {
    if(self.pdfPage != NULL) {
        CGPDFPageRelease(self.pdfPage);
    }
}

#pragma mark - Setters

- (void)setPdfPage:(CGPDFPageRef)pdfPage {
    if(_pdfPage != NULL) {
        CGPDFPageRelease(self.pdfPage);
    }
    if(pdfPage != NULL) {
        _pdfPage = CGPDFPageRetain(pdfPage);
    }
}

@end
