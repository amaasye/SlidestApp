//
//  SessionStatusViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/11/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "SessionStatusViewController.h"
#import <Parse/Parse.h>

@interface SessionStatusViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sessionTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *peerCounterLabel;

@end

@implementation SessionStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(IBAction)unwindToSessionStatusViewController:(UIStoryboardSegue *)sender{

}

//- (IBAction)onEndSessionButtonTapped:(UIButton *)sender {
//    [self.slideshow deleteInBackground];
//    [self.slideshow unpin];
//    [self viewDidLoad];
//}


@end
