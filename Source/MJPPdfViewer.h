//
//  MJPPdfViewer.h
//  SentencingGuidelines
//
//  Created by Mike Platt on 03/11/2014.
//  Copyright (c) 2014 RABFAP Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJPPdfViewer : UIViewController <UIScrollViewDelegate>

// PDF
@property (strong, nonatomic) NSString *path;
@property (assign, nonatomic) NSInteger page;

// styling
@property (assign, nonatomic) CGFloat margin;
@property (assign, nonatomic) BOOL showDoneButton;

@end
