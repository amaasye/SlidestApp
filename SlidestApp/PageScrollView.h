//
//  PageScrollView.h
//  SlidestApp
//
//  Created by Matt on 2/10/15.
//  Copyright (c) 2015 Mateusz Pis, Syed Amaanullah and David Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageScrollView : UIScrollView{
}
@property int pageNr;
@property  CGPDFDocumentRef pdf;


-(void)drawInContext:(CGContextRef)context;
-(void)displayPdf:(CGPDFDocumentRef)pdf;

@end
