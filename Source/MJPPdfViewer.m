//
//  MJPPdfViewer.m
//
//  Created by Mike Platt on 03/11/2014.
//  Copyright (c) 2014 RABFAP Limited. All rights reserved.
//

#import "MJPPdfViewer.h"
#import "MJPPdfPage.h"

@interface MJPPdfViewer ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) CGFloat currentWidth;
@property (assign, nonatomic) CGPDFDocumentRef pdf;
@property (assign, nonatomic) NSInteger numberOfPages;
@property (strong, nonatomic) NSMutableArray *allPages;

@end

@implementation MJPPdfViewer

@synthesize path = _path;

#pragma mark - Life Cycle

- (instancetype)initWithPath:(NSString *)path andPage:(NSInteger)page {
    self = [super init];
    if(self) {
        _page = page - 1;
        self.path = path;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.pagingEnabled = YES;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 1.0;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self drawPagesNow];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat scrollWidth = _scrollView.frame.size.width;
    if(_currentWidth != scrollWidth) {
        _currentWidth = scrollWidth;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _numberOfPages, 0.0);
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * _page, _scrollView.contentOffset.y);
        for(UIView *subView in _scrollView.subviews) {
            if([subView isKindOfClass:[MJPPdfPage class]]) {
                MJPPdfPage *pageView = (MJPPdfPage *)subView;
                CGFloat theX = _scrollView.frame.size.width * (pageView.pageNumber);
                CGFloat theY = 0.0;
                CGFloat theWidth = _scrollView.frame.size.width;
                CGFloat theHeight = _scrollView.frame.size.height + _scrollView.contentOffset.y;
                CGRect frame = CGRectMake(theX, theY, theWidth, theHeight);
                pageView.frame = frame;
                [pageView updateView];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)drawPagesNow {
    
    NSInteger firstPage = _page - 1;
    NSInteger lastPage = _page + 1;
    
    for (NSInteger i = 0; i < firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i = firstPage; i <= lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i = lastPage + 1; i < _allPages.count; i++) {
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page {
    if(page < 0 || page >= _allPages.count) {
        return;
    }
    MJPPdfPage *pageView = [_allPages objectAtIndex:page];
    if((NSNull *)pageView == [NSNull null]) {
        CGPDFPageRef pageRef = CGPDFDocumentGetPage(_pdf, page + 1);
        CGFloat theX = _scrollView.frame.size.width * (page);
        CGFloat theY = 0.0;
        CGFloat theWidth = _scrollView.frame.size.width;
        CGFloat theHeight = _scrollView.frame.size.height + _scrollView.contentOffset.y;
        MJPPdfPage *newPageView = [[MJPPdfPage alloc] initWithFrame:CGRectMake(theX, theY, theWidth, theHeight) andPage:pageRef andPageNumber:page];
        [_scrollView addSubview:newPageView];
        [_allPages replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)purgePage:(NSInteger)page {
    if(page < 0 || page >= _allPages.count) {
        return;
    }
    MJPPdfPage *pageView = [_allPages objectAtIndex:page];
    if((NSNull *)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [_allPages replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

#pragma mark - Scroll View

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // this checks if it isn't a rotation before updating the page number
    if(_scrollView.frame.size.width == _currentWidth) {
        CGFloat position = (scrollView.contentOffset.x / _scrollView.frame.size.width);
        NSInteger newPage = round(position);
        if(newPage != _page) {
            _page = newPage;
            [self drawPagesNow];
        }
    }
}

#pragma mark - Public

- (IBAction)donePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setters

- (void)setPath:(NSString *)path {
    _path = path;
    NSString *fileName = [path stringByDeletingPathExtension];
    NSURL *URL = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"pdf"];
    _pdf = CGPDFDocumentCreateWithURL( (__bridge CFURLRef) URL );
    _numberOfPages = CGPDFDocumentGetNumberOfPages( _pdf );
    _allPages = nil;
    _allPages = [NSMutableArray new];
    for(int i = 0; i < _numberOfPages; i++) {
        [_allPages addObject:[NSNull null]];
    }
}

@end
