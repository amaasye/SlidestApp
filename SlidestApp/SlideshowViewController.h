//
//  SlideshowViewController.h
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/9/15.
//  Copyright (c) 2015 Mateusz Pis, Syed Amaanullah and David Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataHandler.h"

@interface SlideshowViewController : UIViewController{
    int fromPointX;
    int fromPointY;

    int toPointX;
    int toPointY;
    NSString *currenDrawColor;
}
@property DataHandler *dataHandler;
@property BOOL presenter;

-(void)drawGestureWithpoint:(CGPoint)point andColor:(NSString*)color;

@end
