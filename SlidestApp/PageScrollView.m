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
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, self.frame.size.height-5);
    CGContextScaleCTM(context, 1, -1);

    CGPDFPageRef page = CGPDFDocumentGetPage(self.pdf, self.pageNr+1);


    CGContextSaveGState(context);

    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, self.bounds, 0, true);
    CGContextConcatCTM(context, pdfTransform);
    CGContextDrawPDFPage(context, page);
    CGContextRestoreGState(context);
}
@end
