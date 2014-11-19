//
//  MJPPdfTiledView.h
//  MJPPdfViewer
//
//  Created by Mike Platt on 18/11/2014.
//  Copyright (c) 2014 RABFAP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJPPdfTiledView : UIView

- (id)initWithFrame:(CGRect)frame page:(CGPDFPageRef)page scale:(CGFloat)scale;

@end
