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
@property (strong, nonatomic) NSMutableIndexSet *drawnPages;

@end

@implementation MJPPdfViewer

@synthesize path = _path;
@synthesize page = _page;

#pragma mark - Life Cycle

- (instancetype)initWithPath:(NSString *)path andPage:(NSInteger)page {
    self = [super init];
    if(self) {
        self.path = path;
        self.page = page;
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat scrollWidth = _scrollView.frame.size.width;
    if(_currentWidth != scrollWidth) {
        _currentWidth = scrollWidth;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * (_numberOfPages), 0.0);
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * (_page - 1), _scrollView.contentOffset.y);
    }
    for(UIView *subView in _scrollView.subviews) {
        if([subView isKindOfClass:[MJPPdfPage class]]) {
            MJPPdfPage *page = (MJPPdfPage *)subView;
            CGFloat theX = _scrollView.frame.size.width * (page.pageNumber - 1);
            CGFloat theY = 0.0;
            CGFloat theWidth = _scrollView.frame.size.width;
            CGFloat theHeight = _scrollView.frame.size.height + _scrollView.contentOffset.y;
            CGRect frame = CGRectMake(theX, theY, theWidth, theHeight);
            page.frame = frame;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)drawPagesNow {
    if(!_drawnPages) {
        _drawnPages = [NSMutableIndexSet new];
    }
    // draw pages either side (this doesn't help as the page is only rendered when it comes on screen - MJP)
    for(NSInteger i = self.page - 1; i <= self.page + 1; i++) {
        [self drawPage:i];
    }
}

- (void)drawPage:(NSInteger)pageNumber {
    if(pageNumber > 0 && pageNumber <= _numberOfPages && ![_drawnPages containsIndex:pageNumber]) {
        NSLog(@"DRAWING: %ld", (long)pageNumber);
        CGPDFPageRef pageRef = CGPDFDocumentGetPage(_pdf, pageNumber);
        MJPPdfPage *pageView = [[MJPPdfPage alloc] initWithFrame:CGRectZero andPage:pageRef andPageNumber:pageNumber];
        [_scrollView addSubview:pageView];
        [_drawnPages addIndex:pageNumber];
        [self viewDidLayoutSubviews];
    }
}

#pragma mark - Scroll View

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat position = (scrollView.contentOffset.x / _scrollView.frame.size.width);
    NSInteger newPage = round(position) + 1;
    if(newPage != _page) {
        _page = newPage;
        [self drawPagesNow];
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
}

@end
