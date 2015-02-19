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
    }
    _pageView = pageView;

    [self addSubview:_pageView];

}

@end
