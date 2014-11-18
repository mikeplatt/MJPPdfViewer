//
//  MJPPdfPage.m
//  SentencingGuidelines
//
//  Created by Mike Platt on 04/11/2014.
//  Copyright (c) 2014 Ambay Software Ltd. All rights reserved.
//

#import "MJPPdfPage.h"
#import "MJPPdfView.h"

static const CGFloat MJPPdfViewerMargin = 20.0;

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
@synthesize stopUpdate = _stopUpdate;

- (instancetype)initWithFrame:(CGRect)frame andPage:(CGPDFPageRef)page andPageNumber:(NSInteger)pageNumber {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor redColor];
        self.delegate = self;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 5.0;
        self.pageNumber = pageNumber;
        self.page = page;
    }
    return self;
}

- (void)layoutSubviews {
    if(!_stopUpdate) {
        [self updateView];
    }
    [super layoutSubviews];
}

- (void)updateView {
    
    CGRect pageRect = CGPDFPageGetBoxRect(_page, kCGPDFMediaBox);
    
    CGFloat frameWidth = self.frame.size.width - (2 * MJPPdfViewerMargin);
    CGFloat frameHeight = self.frame.size.height - (2 * MJPPdfViewerMargin);
    
    CGFloat xScale = frameWidth / pageRect.size.width;
    CGFloat yScale = frameHeight / pageRect.size.height;
    _scale = MIN( xScale, yScale );
    _currentScale = _scale;
    
    CGFloat theWidth = (yScale > xScale) ? frameWidth : (pageRect.size.width * _scale);
    CGFloat theHeight = (yScale > xScale) ? (pageRect.size.height * _scale) : frameHeight;
    
    _currentX = (yScale > xScale) ? MJPPdfViewerMargin : (self.frame.size.width - theWidth) / 2;
    _currentY = (yScale > xScale) ? (self.frame.size.height - theHeight) / 2 : MJPPdfViewerMargin;
    
    [self updateViewWithFrame:CGRectMake(_currentX, _currentY, theWidth, theHeight) andScale:_scale];
}

- (void)updateViewWithFrame:(CGRect)frame andScale:(CGFloat)scale {
    
    if(_tiledView) {
        _oldView = _tiledView;
    }
    
    _tiledView = [[MJPPdfView alloc] initWithFrame:frame andScale:scale];
    _tiledView.pdfPage = _page;
    [self addSubview:_tiledView];
    [self sendSubviewToBack:_tiledView];
    
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
    NSLog(@"scrollViewDidEndZooming");
    if(self.zoomScale == 1.0) {
        self.stopUpdate = NO;
    } else {
        NSLog(@"SCALE: %.2f", scale);
        NSLog(@"FRAME: %@", NSStringFromCGRect(_tiledView.frame));
        NSLog(@"BEFORE: %@", NSStringFromCGSize(scrollView.contentSize));
        CGSize contentSize = scrollView.contentSize;
        contentSize.width += _currentX * 2;
        contentSize.height += _currentY * 2;
        scrollView.contentSize = contentSize;
        NSLog(@"AFTER: %@", NSStringFromCGSize(scrollView.contentSize));
    }
}

#pragma mark - Setters

- (void)setPage:(CGPDFPageRef)page {
    _page = page;
    //[self updateView];
}

- (void)setStopUpdate:(BOOL)stopUpdate {
    _stopUpdate = stopUpdate;
}

@end
