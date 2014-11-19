//
//  MJPPdfViewer.h
//  SentencingGuidelines
//
//  Created by Mike Platt on 03/11/2014.
//  Copyright (c) 2014 RABFAP Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  <#Description#>
 */

@interface MJPPdfViewer : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) NSString *fileName;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) CGFloat margin;
@property (assign, nonatomic) BOOL showDoneButton;

@end
