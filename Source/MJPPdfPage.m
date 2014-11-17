//
//  MJPPdfPage.m
//  SentencingGuidelines
//
//  Created by Mike Platt on 04/11/2014.
//  Copyright (c) 2014 Ambay Software Ltd. All rights reserved.
//

#import "MJPPdfPage.h"
#import "MJPPdfView.h"

static const CGFloat PDFViewerMargin = 20.0;

@interface MJPPdfPage ()

@property (strong, nonatomic) MJPPdfView *tiledView;
@property (strong, nonatomic) MJPPdfView *oldView;
@property (assign, nonatomic) CGFloat scale;


@property (assign, nonatomic) NSLayoutConstraint *centerXConstraint;
@property (assign, nonatomic) NSLayoutConstraint *centerYConstraint;
@property (assign, nonatomic) NSLayoutConstraint *widthConstraint;
@property (assign, nonatomic) NSLayoutConstraint *heightConstraint;

@end

@implementation MJPPdfPage

@synthesize page = _page;
@synthesize stopUpdate = _stopUpdate;

- (instancetype)initWithFrame:(CGRect)frame andPage:(CGPDFPageRef)page andPageNumber:(NSInteger)pageNumber {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor redColor];
        self.delegate = self;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 5;
        self.page = page;
        self.pageNumber = pageNumber;
    }
    return self;
}

- (void)layoutSubviews {
    if(!self.stopUpdate) {
        [self updateTiledView];
    }
    [super layoutSubviews];
}

- (void)updateTiledView {
    
    if(_tiledView) {
        _oldView = _tiledView;
    }
    
    CGRect pageRect = CGPDFPageGetBoxRect(_page, kCGPDFMediaBox);
    
    CGFloat frameWidth = self.frame.size.width - (2 * PDFViewerMargin);
    CGFloat frameHeight = self.frame.size.height - (2 * PDFViewerMargin);
    
    CGFloat xScale = frameWidth / pageRect.size.width;
    CGFloat yScale = frameHeight / pageRect.size.height;
    _scale = MIN( xScale, yScale );
    
    CGFloat theWidth = (yScale > xScale) ? frameWidth : (pageRect.size.width * _scale);
    CGFloat theHeight = (yScale > xScale) ? (pageRect.size.height * _scale) : frameHeight;
    
    CGFloat theX = (yScale > xScale) ? PDFViewerMargin : (self.frame.size.width - theWidth) / 2;
    CGFloat theY = (yScale > xScale) ? (self.frame.size.height - theHeight) / 2 : PDFViewerMargin;
    
    _tiledView = [[MJPPdfView alloc] initWithFrame:CGRectMake(theX, theY, theWidth, theHeight) andScale:_scale];
    _tiledView.pdfPage = _page;
    _tiledView.contentScaleFactor = 1.0;
    [self addSubview:_tiledView];
    
    self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
    [_oldView removeFromSuperview];
    _oldView = nil;
    
}

#pragma mark - Scroll View

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _tiledView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    self.stopUpdate = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if(self.zoomScale == 1.0) {
        self.stopUpdate = NO;
    }
}

#pragma mark - Setters

- (void)setPage:(CGPDFPageRef)page {
    _page = page;
    [self updateTiledView];
}

- (void)setStopUpdate:(BOOL)stopUpdate {
    _stopUpdate = stopUpdate;
}

@end
