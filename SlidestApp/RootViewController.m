//
//  ViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/9/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "RootViewController.h"
#import "DataHandler.h"
@interface RootViewController () <DataHandlerDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(IBAction)unwind:(UIStoryboardSegue *)segue {
//    //should delete the file from local storage
//    if ([segue.sourceViewController isKindOfClass:[JoinViewController class]]) {
//        JoinViewController *joinVC = segue.sourceViewController;
//        joinVC.object = self.object;
//        [self.object unpin];
//    }
}



@end
