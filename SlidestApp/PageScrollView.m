//
//  PageScrollView.m
//  SlidestApp
//
//  Created by Matt on 2/10/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "PageScrollView.h"

@implementation PageScrollView

-(void)openFile{

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self drawInContext:UIGraphicsGetCurrentContext()];


}
- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor clearColor];
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [searchPaths objectAtIndex:0];
    NSString *tempPath = [documentsDirectoryPath stringByAppendingPathComponent:@"pdf.pdf"];

    //Display PDF
    CFURLRef pdfURL = CFURLCreateWithFileSystemPath (NULL, (CFStringRef)tempPath, kCFURLPOSIXPathStyle, FALSE);
    pdf = CGPDFDocumentCreateWithProvider(CGDataProviderCreateWithURL(pdfURL));
    self.pageNr = 1;
    [self drawInContext:UIGraphicsGetCurrentContext()];
}

-(void)drawInContext:(CGContextRef)context {
    // PDF page drawing expects a Lower-Left coordinate system, so we flip the coordinate system
    // before we start drawing.
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);

    // Grab the first PDF page
    CGPDFPageRef page = CGPDFDocumentGetPage(pdf, self.pageNr);
    // We're about to modify the context CTM to draw the PDF page where we want it, so save the graphics state in case we want to do more drawing
    CGContextSaveGState(context);
    // CGPDFPageGetDrawingTransform provides an easy way to get the transform for a PDF page. It will scale down to fit, including any
    // base rotations necessary to display the PDF page correctly.
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, self.bounds, 0, true);
    // And apply the transform.
    CGContextConcatCTM(context, pdfTransform);
    // Finally, we draw the page and restore the graphics state for further manipulations!
    CGContextDrawPDFPage(context, page);
    CGContextRestoreGState(context);
}

@end
