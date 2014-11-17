//
//  ViewController.m
//  MJPPdfViewer
//
//  Created by Mike Platt on 17/11/2014.
//  Copyright (c) 2014 RABFAP. All rights reserved.
//

#import "ViewController.h"
#import "MJPPdfViewer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPDF:(UIButton *)sender {
    NSString *path;
    switch (sender.tag) {
        case 0:
            path = @"A4-landscape.pdf";
            break;
        case 1:
            path = @"A4-portrait.pdf";
            break;
        case 2:
            path = @"square.pdf";
            break;
        default:
            break;
    }
    
    MJPPdfViewer *pdfViewer = [[MJPPdfViewer alloc] initWithPath:path];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pdfViewer];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
