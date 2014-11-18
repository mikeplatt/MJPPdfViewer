//
//  MJPPdfTiledView.h
//  SentencingGuidelines
//
//  Created by Mike Platt on 31/10/2014.
//  Copyright (c) 2014 Ambay Software Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MJPPdfView : UIView

@property (assign, nonatomic) CGPDFPageRef pdfPage;
@property (assign, nonatomic) NSInteger pageNumber;
- (id)initWithFrame:(CGRect)frame andScale:(CGFloat)scale;

@end
