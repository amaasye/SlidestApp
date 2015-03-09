//
//  CustomCell.h
//  SlidestApp
//
//  Created by Matt on 2/11/15.
//  Copyright (c) 2015 Mateusz Pis, Syed Amaanullah and David Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageScrollView.h"

@interface CustomCell : UICollectionViewCell{

     UIBezierPath *path;
    UIImage *bezierImage;

    CGContextRef context;

}

@property (nonatomic) PageScrollView *pageView;
@property UIImageView *drawImageView;


-(void)addDrawFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint withColor:(NSString*)color;

@end
