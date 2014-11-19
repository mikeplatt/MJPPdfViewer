[![License: MIT](https://img.shields.io/badge/license-MIT-red.svg?style=flat)](https://github.com/fastred/MJPPdfViewer/blob/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/v/MJPPdfViewer.svg?style=flat)](https://github.com/fastred/MJPPdfViewer)

## Synopsis

`MJPPdfViewer` is a simple iOS PDF viewer currently optimised to view locally stored PDF files. 

/*![screenshot] (https://github.com/mikeplatt/MJPSlider/blob/master/screenshot.png)*/


## Installation
 
 `MJPPdfViewer` is available through [CocoaPods](http://cocoapods.org/?q=MJPPdfViewer). To install it, simply add the following line to your Podfile:
 
 `pod 'MJPPdfViewer'`
 
 If you don't use CocoaPods, just include these files in your project:

`MJPPdfViewer.h`<br>
`MJPPdfViewer.m`<br>
`MJPPdfPage.h`<br>
`MJPPdfPage.m`<br>
`MJPPdfView.h`<br>
`MJPPdfView.m`<br>
`MJPPdfTiledView.h`<br>
`MJPPdfTiledView.m`<br>


## Standard Features
• `path` NSString <br>
• `page`<br>
• `margin`<br>
• `showDoneButton`<br>

## Code Example
```objective-c
MJPPdfViewer *pdfViewer = [[MJPPdfViewer alloc] init];
pdfViewer.path = path;
pdfViewer.page = 10;
pdfViewer.margin = 10.0;
UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pdfViewer];
[self presentViewController:navigationController animated:YES completion:nil];
```


