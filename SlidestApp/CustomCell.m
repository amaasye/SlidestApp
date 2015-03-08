//
//  CustomCell.m
//  SlidestApp
//
//  Created by Matt on 2/11/15.
//  Copyright (c) 2015 Mateusz Pis, Syed Amaanullah and David Miller. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell


-(void)setPageView:(PageScrollView *)pageView{

    if(_pageView != nil){
        [_pageView removeFromSuperview];
        [self.drawImageView removeFromSuperview];
    }
    _pageView = pageView;

    //[self addSubview:_pageView];
    [self insertSubview:_pageView atIndex:2];
   CGRect frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.drawImageView = [[UIImageView alloc] initWithFrame:frame];
    bezierImage = [[UIImage alloc]init];

}

-(void)addDrawFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint{



    UIGraphicsBeginImageContext(self.drawImageView.frame.size);
    [self.drawImageView.image drawInRect:CGRectMake(0, 0, self.drawImageView.frame.size.width, self.drawImageView.frame.size.height)];
    [[UIColor blackColor] set];
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0f);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), fromPoint.x, fromPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), toPoint.x , toPoint.y);

    CGContextStrokePath(UIGraphicsGetCurrentContext());

    bezierImage = UIGraphicsGetImageFromCurrentImageContext();
    self.drawImageView.image = bezierImage;
    UIGraphicsEndImageContext();
    [self addSubview:self.drawImageView];

}

@end
