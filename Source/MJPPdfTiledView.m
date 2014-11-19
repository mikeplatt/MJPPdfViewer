//
//  MJPPdfTiledView.m
//  MJPPdfViewer
//
//  Created by Mike Platt on 18/11/2014.
//  Copyright (c) 2014 RABFAP. All rights reserved.
//

#import "MJPPdfTiledView.h"

@interface MJPPdfTiledView ()

@property (assign, nonatomic) CGFloat scale;
@property (assign, nonatomic) CGPDFPageRef page;

@end

@implementation MJPPdfTiledView

- (id)initWithFrame:(CGRect)frame page:(CGPDFPageRef)page scale:(CGFloat)scale
{
    self = [super initWithFrame:frame];
    if (self) {
        CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
        tiledLayer.levelsOfDetail = 4;
        tiledLayer.levelsOfDetailBias = 3;
        tiledLayer.tileSize = CGSizeMake(512.0, 512.0);
        _scale = scale;
        _page = page;
    }
    return self;
}

+ (Class)layerClass {
    return [CATiledLayer class];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
    CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
    CGContextFillRect(context, self.bounds);
    
    if(_page == NULL) {
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextScaleCTM(context, _scale, _scale);
    CGContextDrawPDFPage(context, _page);
    CGContextRestoreGState(context);
}


- (void)dealloc {
    if(_page != NULL) {
        //CGPDFPageRelease(_page);
    }
}

@end
