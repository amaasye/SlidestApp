//
//  ViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/9/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "RootViewController.h"
#import "SlideshowViewController.h"
#import "POP/POP.h"

@interface RootViewController () <DataHandlerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *createSlideshowButton;
@property (weak, nonatomic) IBOutlet UILabel *horizontalLine;
@property (weak, nonatomic) IBOutlet UIButton *joinOneButton;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datahandler = [DataHandler new];
    self.datahandler.delegate = self;
    self.passcodeTextField.hidden = YES;
    self.goButton.hidden = YES;
    [self setUIElements];
}

-(void)setUIElements{
    self.createSlideshowButton.backgroundColor = [UIColor colorWithRed:.44 green:.62 blue:.80 alpha:1];
    
}
- (IBAction)onJoinButtonTapped:(UIButton *)sender {
    POPDecayAnimation *anim = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anim.velocity = @(1500.);
    [self.joinOneButton pop_addAnimation:anim forKey:@"slide"];

    POPDecayAnimation *anime = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anime.velocity = @(1500.);
    [self.createSlideshowButton pop_addAnimation:anime forKey:@"slide"];
    self.passcodeTextField.hidden = NO;
    self.goButton.hidden = NO;
    self.joinOneButton.hidden = YES;
}


- (IBAction)onGoButtonTapped:(UIButton *)sender {
    [self.datahandler pullFromDataBase:self.passcodeTextField.text];
}

- (void)dataDownloaded {
    [self performSegueWithIdentifier:@"slideshowVCfromJoinVC" sender:self];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"slideshowVCfromJoinVC"]){

        SlideshowViewController *svc = [segue destinationViewController];
        svc.dataHandler = self.datahandler;
    }
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
