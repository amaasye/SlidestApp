//
//  JoinViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/9/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "JoinViewController.h"
#import <Parse/Parse.h>
#import "SlideshowViewController.h"

@interface JoinViewController () <DataHandlerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;


@end

@implementation JoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datahandler = [DataHandler new];
    self.datahandler.delegate = self;

}
- (IBAction)onGoButtonTapped:(UIButton *)sender {
    [self.datahandler parseQuery:self.passcodeTextField.text];
}

- (void)segueToSlideshow {
    [self performSegueWithIdentifier:@"slideshowVCfromJoinVC" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"slideshowVCfromJoinVC"]){

    SlideshowViewController *svc = [segue destinationViewController];
    svc.dataHandler = self.datahandler;
    }
}
-(IBAction)unwindToJoinVC:(UIStoryboardSegue *)sender{
    [self.datahandler deleteFile];
}


@end
