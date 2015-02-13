//
//  SessionStatusViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/11/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "SessionStatusViewController.h"
#import "DataHandler.h"

@interface SessionStatusViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sessionTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *peerCounterLabel;
@property DataHandler *dataHandler;
@end

@implementation SessionStatusViewController

- (void)viewDidLoad {
    self.dataHandler = [DataHandler new];
    [super viewDidLoad];
    
}

-(IBAction)unwindToSessionStatusViewController:(UIStoryboardSegue *)sender{

}

- (IBAction)onEndSessionButtonTapped:(UIButton *)sender {


}


@end
