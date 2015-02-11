//
//  PageCellCollectionViewCell.h
//  SlidestApp
//
//  Created by Matt on 2/10/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageCell : UICollectionViewCell{
    CGPDFDocumentRef pdf;
}
@property int pageNr;

-(void)drawInContext:(CGContextRef)context;
-(void)openFile;



@end
