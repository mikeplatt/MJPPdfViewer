//
//  MJPPdfPage.h
//  SentencingGuidelines
//
//  Created by Mike Platt on 04/11/2014.
//  Copyright (c) 2014 Ambay Software Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MJPPdfPage : UIScrollView <UIScrollViewDelegate>

@property (assign, nonatomic) CGPDFPageRef page;
@property (assign, nonatomic) NSInteger pageNumber;
@property (assign, nonatomic) CGFloat margin;

- (instancetype)initWithFrame:(CGRect)frame page:(CGPDFPageRef)page pageNumber:(NSInteger)pageNumber margin:(CGFloat)margin;
- (void)updateView;
- (void)resetZoom;

@end
