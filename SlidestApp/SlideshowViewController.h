//
//  SlideshowViewController.h
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/9/15.
//  Copyright (c) 2015 Mateusz Pis, Syed Amaanullah and David Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataHandler.h"

@interface SlideshowViewController : UIViewController
@property DataHandler *dataHandler;
@property BOOL presenter;

@end
