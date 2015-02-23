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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property CGPoint joinButtonCenter;
@property CGPoint goButtonCenter;
@property CGPoint createButtonCenter;
@property POPSpringAnimation *anime;
@property POPAnimation *pop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *joinConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *createConstrain;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *goConstraint;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datahandler = [DataHandler new];
    self.passcodeTextField.delegate = self;
    [self setUIElements];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.datahandler.delegate = self;
}


#pragma mark -- UI Elements and Animations 

-(void)setUIElements{
    self.navigationController.navigationBar.hidden = YES;
    self.spinner.hidden = YES;
    self.createSlideshowButton.backgroundColor = [UIColor colorWithRed:34/255.0f green:167/255.0f blue:240/255.0f alpha:1.0f];
    self.createSlideshowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    self.joinOneButton.enabled = YES;
    self.joinOneButton.backgroundColor = [UIColor colorWithRed:34/255.0f green:167/255.0f blue:240/255.0f alpha:1.0f];
    self.joinOneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.joinOneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.joinOneButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
//    self.joinButtonCenter = self.joinOneButton.center;
//    NSValue *point = [NSValue valueWithCGPoint:self.joinButtonCenter];
//    NSLog(@"%@", point);

    self.goButton.backgroundColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
    self.goButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.goButton.hidden = YES;

    self.passcodeTextField.hidden = YES;
    self.passcodeTextField.text = @"";
}

-(void)elementsAfterAnimation {
    self.joinOneButton.center = self.joinButtonCenter;
}

-(void)animationsOfUIElements {

    //animation for JoinButton
    POPSpringAnimation *joinAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    joinAnimation.springSpeed = 20.0f;
    joinAnimation.springBounciness = 15.0f;
    joinAnimation.toValue = @(-20);
    joinAnimation.delegate = self;
    joinAnimation.removedOnCompletion = YES;
    [self.joinConstraint pop_addAnimation:joinAnimation forKey:@"joinButtonAnime"];

    //annimation for  Button create
    POPSpringAnimation *createAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    createAnimation.springSpeed = 20.0f;
    createAnimation.springBounciness = 15.0f;
    createAnimation.toValue = @(100);
    createAnimation.removedOnCompletion = YES;
    [self.createConstrain pop_addAnimation:createAnimation forKey:@"createButtonAnime"];


    self.passcodeTextField.hidden = NO;
    self.goButton.hidden = NO;

    POPSpringAnimation *goAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    goAnimation.springSpeed = 20.0f;
    goAnimation.springBounciness = 15.0f;
    goAnimation.toValue = @(-80);
    goAnimation.removedOnCompletion = YES;
    [self.goConstraint pop_addAnimation:goAnimation forKey:@"createButtonAnime"];

    POPSpringAnimation *animatePasscodeTextField = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animatePasscodeTextField.springBounciness = 0;
    animatePasscodeTextField.springSpeed = 2;
    animatePasscodeTextField.toValue = @(self.passcodeTextField.center.y - 0);
    animatePasscodeTextField.removedOnCompletion = YES;
    [self.passcodeTextField pop_addAnimation:animatePasscodeTextField forKey:@"positionY"];

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
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
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

   }

#pragma mark -- Data and Segues --

- (void)dataDownloaded {
    [self performSegueWithIdentifier:@"slideshowVCfromJoinVC" sender:self];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([[segue identifier] isEqualToString:@"toCreate"]) {
    }
    else if ([[segue identifier] isEqualToString:@"slideshowVCfromJoinVC"]){
        SlideshowViewController *svc = [segue destinationViewController];
                   svc.dataHandler = self.datahandler;

    }
}


-(IBAction)unwind:(UIStoryboardSegue *)segue {
    self.joinOneButton.enabled = YES;
    [self resignFirstResponder];
    [self setUIElements];

}



@end
