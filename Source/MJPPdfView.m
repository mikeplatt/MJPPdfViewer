//
//  MJPPdfView.m
//  SentencingGuidelines
//
//  Created by Mike Platt on 31/10/2014.
//  Copyright (c) 2014 Ambay Software Ltd. All rights reserved.
//

#import "MJPPdfView.h"
#import <QuartzCore/QuartzCore.h>

@interface MJPPdfView ()

@property (assign, nonatomic) CGFloat scale;
@property (strong, nonatomic) UIImage *pageImage;
@property (strong, nonatomic) UIImageView *pageView;

@end

@implementation MJPPdfView

@synthesize pdfPage = _pdfPage;

- (id)initWithFrame:(CGRect)frame andScale:(CGFloat)scale {
    self = [super initWithFrame:frame];
    if (self) {
        _scale = scale;
        _pageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _pageView.backgroundColor = [UIColor yellowColor];
        _pageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_pageView];
        //self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        //self.layer.borderWidth = 0.5;
    }
    return self;
}

- (void)drawPageNow {
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSLog(@"HIT drawPageNow: %@", _pdfPage);
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
        
            NSLog(@"%@", image);
            weakSelf.pageView.image = image;
            
        });
    });
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
        [self drawPageNow];
    }
}

@end
