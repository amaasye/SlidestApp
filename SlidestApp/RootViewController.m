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
#import "DataHandler.h"

@interface RootViewController () <DataHandlerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *createSlideshowButton;
@property (weak, nonatomic) IBOutlet UIButton *joinOneButton;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.joinOneButton.enabled = YES;
    self.datahandler = [DataHandler new];
    self.datahandler.delegate = self;
    self.passcodeTextField.hidden = YES;
    self.goButton.hidden = YES;
    [self setUIElements];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

#pragma mark -------------------------- UI Elements and Animations --------------------------------------------------

-(void)setUIElements{
    self.createSlideshowButton.backgroundColor = [UIColor colorWithRed:34/255.0f green:167/255.0f blue:240/255.0f alpha:1.0f];
    self.createSlideshowButton.layer.cornerRadius = 0.f;
    self.createSlideshowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    self.joinOneButton.backgroundColor = [UIColor colorWithRed:34/255.0f green:167/255.0f blue:240/255.0f alpha:1.0f];
    self.joinOneButton.layer.cornerRadius = 0.f;
    self.joinOneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.joinOneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.joinOneButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];


    self.goButton.backgroundColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
    self.goButton.layer.cornerRadius = 0.f;
    self.goButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

-(void)animationsOfUIElements {
    POPSpringAnimation *animateJoin = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animateJoin.springBounciness = 0;
    animateJoin.springSpeed = 2;
    animateJoin.toValue = @(self.joinOneButton.center.y + 82);
    [self.joinOneButton pop_addAnimation:animateJoin forKey:@"postionX"];

    POPSpringAnimation *anime = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anime.springBounciness = 0;
    anime.springSpeed = 2;
    anime.toValue = @(self.createSlideshowButton.center.y - 30);
    [self.createSlideshowButton pop_addAnimation:anime forKey:@"pop"];

    self.passcodeTextField.hidden = NO;
    self.goButton.hidden = NO;

    POPSpringAnimation *animateGo = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animateGo.springBounciness = 10;
    animateGo.springSpeed = 10;
    animateGo.toValue = @(self.goButton.center.y - 64);
    [self.goButton pop_addAnimation:animateGo forKey:@"positionY"];

    self.joinOneButton.enabled = NO;

}

#pragma mark ---------------------------------- Actions -------------------------------------------------------------

- (IBAction)onJoinButtonTapped:(UIButton *)sender {
    if (self.joinOneButton.enabled == YES) {
    [self animationsOfUIElements];
    }
    else {
       self.joinOneButton.backgroundColor = [UIColor colorWithRed:34/255.0f green:167/255.0f blue:240/255.0f alpha:0.5f];
    }
}

- (IBAction)onGoButtonTapped:(UIButton *)sender {
    [self.datahandler pullFromDataBase:self.passcodeTextField.text];
}

#pragma mark ---------------------------------- Data ----------------------------------------------------------------

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

}



@end
