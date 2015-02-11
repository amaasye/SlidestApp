//
//  SessionStatusViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/11/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "SessionStatusViewController.h"

@interface SessionStatusViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sessionTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *peerCounterLabel;

@end

@implementation SessionStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sessionTextLabel.numberOfLines = 0;
    self.sessionTextLabel.text = @"Session started\rWaiting for peers to join";
    [self.sessionTextLabel sizeToFit];
}

-(IBAction)unwindToSessionStatusViewController:(UIStoryboardSegue *)sender{

}


@end