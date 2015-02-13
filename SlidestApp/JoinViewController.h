//
//  JoinViewController.h
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/9/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "DataHandler.h"

@interface JoinViewController : UIViewController
@property PFObject *object;
@property DataHandler *datahandler;

@end
