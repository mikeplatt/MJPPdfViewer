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
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) CGPDFDocumentRef pdf;
@property (assign, nonatomic) NSInteger numberOfPages;
@property (strong, nonatomic) NSMutableIndexSet *drawnPages;

@end

@implementation MJPPdfViewer

@synthesize path = _path;

#pragma mark - Life Cycle

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if(self) {
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
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    _page = 1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self drawPagesNow];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * (_numberOfPages), 0.0);
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * (_page - 1), _scrollView.contentOffset.y);
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
    for(NSInteger i = [self previousPage]; i <= [self nextPage]; i++) {
        [self drawPage:i];
    }
}

- (void)drawPage:(NSInteger)pageNumber {
    if(pageNumber > 0 && pageNumber <= _numberOfPages && ![_drawnPages containsIndex:pageNumber]) {
        CGPDFPageRef pageRef = CGPDFDocumentGetPage(_pdf, pageNumber);
        MJPPdfPage *pageView = [[MJPPdfPage alloc] initWithFrame:CGRectZero andPage:pageRef andPageNumber:pageNumber];
        [_scrollView addSubview:pageView];
        [_drawnPages addIndex:pageNumber];
        [self viewDidLayoutSubviews];
    }
}

#pragma mark - Scroll View

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _page = (scrollView.contentOffset.x / _scrollView.frame.size.width) + 1;
    [self drawPagesNow];
}

#pragma mark - Public

- (IBAction)donePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getters

- (NSInteger)previousPage {
    return _page - 1;
}

- (NSInteger)nextPage {
    return _page + 1;
}

#pragma mark - Setters

- (void)setPath:(NSString *)path {
    _path = path;
    NSString *fileName = [path stringByDeletingPathExtension];
    NSURL *URL = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"pdf"];
    _pdf = CGPDFDocumentCreateWithURL( (__bridge CFURLRef) URL );
    _numberOfPages = CGPDFDocumentGetNumberOfPages( _pdf );
    NSLog(@"No: %ld", (long)_numberOfPages);
}

@end
