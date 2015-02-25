//
//  PageScrollView.m
//  SlidestApp
//
//  Created by Matt on 2/10/15.
//  Copyright (c) 2015 Mateusz Pis, Syed Amaanullah and David Miller. All rights reserved.
//

#import "PageScrollView.h"

@implementation PageScrollView


-(void)displayPdf:(CGPDFDocumentRef)pdf{
    self.pdf = pdf;

}

- (void)drawRect:(CGRect)rect {
       [self drawInContext:UIGraphicsGetCurrentContext()];
    

}
-(void)drawInContext:(CGContextRef)context {
    // PDF page drawing expects a Lower-Left coordinate system, so we flip the coordinate system
    // before we start drawing.
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, self.frame.size.height-5);
    CGContextScaleCTM(context, 1, -1);

    // Grab the first PDF page
    CGPDFPageRef page = CGPDFDocumentGetPage(self.pdf, self.pageNr+1);


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
