//
//  MJPPdfViewer.h
//  SentencingGuidelines
//
//  Created by Mike Platt on 03/11/2014.
//  Copyright (c) 2014 RABFAP Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJPPdfViewer : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) NSString *path;
@property (assign, nonatomic) NSInteger page;

- (instancetype)initWithPath:(NSString *)path andPage:(NSInteger)page;

@end
