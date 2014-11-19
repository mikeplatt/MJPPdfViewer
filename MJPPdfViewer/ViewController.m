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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // storyboard instantiation
    if([segue.identifier isEqualToString:@"showLandscape"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        MJPPdfViewer *pdfViewer = (MJPPdfViewer *)navigationController.childViewControllers[0];
        pdfViewer.path = @"A4-landscape.pdf";
        pdfViewer.page = 1;
    }
}

- (IBAction)showPDF:(UIButton *)sender {
    
    // programmatic instantiation
    NSString *path;
    switch (sender.tag) {
        case 2:
            path = @"A4-portrait.pdf";
            break;
        case 3:
            path = @"square.pdf";
            break;
        default:
            break;
    }
    
    MJPPdfViewer *pdfViewer = [[MJPPdfViewer alloc] init];
    pdfViewer.path = path;
    pdfViewer.page = sender.tag;
    pdfViewer.margin = 100.0;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pdfViewer];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
