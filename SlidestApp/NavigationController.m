//
//  NavigationController.m
//  SlidestApp
//
//  Created by Matt on 2/24/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {

    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

@end
