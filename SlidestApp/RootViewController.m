//
//  ViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/9/15.
//  Copyright (c) 2015 Mateusz Pis, Syed Amaanullah and David Miller. All rights reserved.
//

#import "RootViewController.h"
#import "SlideshowViewController.h"
#import "POP/POP.h"
#import "DataHandler.h"

@interface RootViewController () <DataHandlerDelegate, UITextFieldDelegate, POPAnimationDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *createSlideshowButton;
@property (weak, nonatomic) IBOutlet UIButton *joinOneButton;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property CGPoint joinButtonCenter;
@property CGPoint goButtonCenter;
@property CGPoint createButtonCenter;
@property POPSpringAnimation *anime;
@property POPAnimation *pop;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datahandler = [DataHandler new];
    self.datahandler.delegate = self;
    self.passcodeTextField.delegate = self;
    self.anime.delegate = self;
    [self setUIElements];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}


#pragma mark -- UI Elements and Animations --

-(void)setUIElements{
    self.createSlideshowButton.backgroundColor = [UIColor colorWithRed:34/255.0f green:167/255.0f blue:240/255.0f alpha:1.0f];
    self.createSlideshowButton.layer.cornerRadius = 0.f;
    self.createSlideshowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    self.joinOneButton.enabled = YES;
    self.joinOneButton.backgroundColor = [UIColor colorWithRed:34/255.0f green:167/255.0f blue:240/255.0f alpha:1.0f];
    self.joinOneButton.layer.cornerRadius = 0.f;
    self.joinOneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.joinOneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.joinOneButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
//    self.joinButtonCenter = self.joinOneButton.center;
//    NSValue *point = [NSValue valueWithCGPoint:self.joinButtonCenter];
//    NSLog(@"%@", point);


    self.goButton.backgroundColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
    self.goButton.layer.cornerRadius = 0.f;
    self.goButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.goButton.hidden = YES;

    self.passcodeTextField.hidden = YES;
    self.passcodeTextField.text = @"";
}

-(void)elementsAfterAnimation {
    self.joinOneButton.center = self.joinButtonCenter;
}

-(void)animationsOfUIElements {

    POPSpringAnimation *animateJoin = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animateJoin.springBounciness = 0;
    animateJoin.springSpeed = 2;
    animateJoin.toValue = @(self.joinOneButton.center.y + 82);
    animateJoin.removedOnCompletion = YES;
    [self.joinOneButton pop_addAnimation:animateJoin forKey:@"postionX"];

    //trying to fix the automatic resetting of the animation when in textfield
    self.joinButtonCenter = self.joinOneButton.center;
    NSValue *point = [NSValue valueWithCGPoint:self.joinButtonCenter];
    NSLog(@"%@", point);


    self.anime = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    self.anime.springBounciness = 0;
    self.anime.springSpeed = 2;
    self.anime.toValue = @(self.createSlideshowButton.center.y - 30);
    [self.createSlideshowButton pop_addAnimation:self.anime forKey:@"pop"];

    self.passcodeTextField.hidden = NO;
    self.goButton.hidden = NO;

    POPSpringAnimation *animateGo = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animateGo.springBounciness = 10;
    animateGo.springSpeed = 10;
    animateGo.toValue = @(self.goButton.center.y - 64);
    [self.goButton pop_addAnimation:animateGo forKey:@"positionY"];

    self.joinOneButton.enabled = NO;

    [self elementsAfterAnimation];
}

#pragma mark -- Actions --

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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self elementsAfterAnimation];
    self.passcodeTextField = textField;
    //trying to fix the automatic resetting of the animation when in textfield
    self.joinOneButton.center = self.joinButtonCenter;
    self.createSlideshowButton.center = self.createButtonCenter;
    NSValue *point = [NSValue valueWithCGPoint:self.joinOneButton.center];
    NSLog(@"%@", point);
}

//-(void)textFieldDidEndEditing:(UITextField *)textField {
//    [self.datahandler pullFromDataBase:self.passcodeTextField.text];
//}

- (void)pop_animationDidStop:(POPSpringAnimation *)anim finished:(BOOL)finished {
    anim = self.anime;
    NSLog(@"Hi");
}

#pragma mark -- Data --

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
    self.joinOneButton.enabled = YES;
    [self setUIElements];

}



@end
