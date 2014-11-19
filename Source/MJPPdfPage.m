//
//  MJPPdfPage.m
//  SentencingGuidelines
//
//  Created by Mike Platt on 04/11/2014.
//  Copyright (c) 2014 Ambay Software Ltd. All rights reserved.
//

#import "MJPPdfPage.h"
#import "MJPPdfView.h"

@interface MJPPdfPage ()

@property (strong, nonatomic) MJPPdfView *tiledView;
@property (strong, nonatomic) MJPPdfView *oldView;
@property (assign, nonatomic) CGFloat scale;
@property (assign, nonatomic) CGFloat currentScale;
@property (assign, nonatomic) CGFloat currentX;
@property (assign, nonatomic) CGFloat currentY;


@property (assign, nonatomic) NSLayoutConstraint *centerXConstraint;
@property (assign, nonatomic) NSLayoutConstraint *centerYConstraint;
@property (assign, nonatomic) NSLayoutConstraint *widthConstraint;
@property (assign, nonatomic) NSLayoutConstraint *heightConstraint;

@end

@implementation MJPPdfPage

@synthesize page = _page;

- (instancetype)initWithFrame:(CGRect)frame page:(CGPDFPageRef)page pageNumber:(NSInteger)pageNumber margin:(CGFloat)margin {
    self = [super initWithFrame:frame];
    if(self) {
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 5.0;
        self.margin = margin;
        self.pageNumber = pageNumber;
        self.page = page;
    }
    return self;
}

- (void)updateView {
    
    if(self.zoomScale > 1.0) {
        [self resetZoom];
    }
    
    CGRect pageRect = CGPDFPageGetBoxRect(_page, kCGPDFMediaBox);
    
    CGFloat frameWidth = self.frame.size.width - (2 * self.margin);
    CGFloat frameHeight = self.frame.size.height - (2 * self.margin);
    
    CGFloat xScale = frameWidth / pageRect.size.width;
    CGFloat yScale = frameHeight / pageRect.size.height;
    _scale = MIN( xScale, yScale );
    
    CGFloat theWidth = (yScale > xScale) ? frameWidth : (pageRect.size.width * _scale);
    CGFloat theHeight = (yScale > xScale) ? (pageRect.size.height * _scale) : frameHeight;
    
    _currentX = (yScale > xScale) ? self.margin : (self.frame.size.width - theWidth) / 2;
    _currentY = (yScale > xScale) ? (self.frame.size.height - theHeight) / 2 : self.margin;
    
    if(_tiledView) {
        _oldView = _tiledView;
    }
    
    _tiledView = [[MJPPdfView alloc] initWithFrame:CGRectMake(_currentX, _currentY, theWidth, theHeight) andScale:_scale];
    _tiledView.pdfPage = _page;
    [self addSubview:_tiledView];
    
    [_oldView removeFromSuperview];
    _oldView = nil;
}

#pragma mark - Scroll View

- (void)resetZoom {
    [self zoomToRect:self.bounds animated:NO];
    [self setContentOffset:CGPointZero animated:NO];
    self.contentSize = CGSizeZero;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _tiledView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    _tiledView.zoomed = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    CGSize contentSize = scrollView.contentSize;
    contentSize.width += _currentX * 2;
    contentSize.height += _currentY * 2;
    scrollView.contentSize = contentSize;
    if(scale > 1.0) {
        [_tiledView drawTiledPDFPageAtScale:_scale];
    } else {
        [_tiledView removeTiledPDFPage];
    }
}

#pragma mark - Setters

- (void)setPage:(CGPDFPageRef)page {
    _page = page;
    [self updateView];
}

@end
