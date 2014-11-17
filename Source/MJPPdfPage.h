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
@property (assign, nonatomic) BOOL stopUpdate;
@property (assign, nonatomic) NSInteger pageNumber;

- (instancetype)initWithFrame:(CGRect)frame andPage:(CGPDFPageRef)page andPageNumber:(NSInteger)pageNumber;
- (void)updateTiledView;

@end
