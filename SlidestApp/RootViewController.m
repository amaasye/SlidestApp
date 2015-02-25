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
#import <QuartzCore/QuartzCore.h>

@interface RootViewController () <DataHandlerDelegate, UITextFieldDelegate, POPAnimationDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *createSlideshowButton;
@property (weak, nonatomic) IBOutlet UIButton *joinOneButton;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *joinConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *createConstrain;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *goConstraint;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datahandler = [DataHandler new];
    self.passcodeTextField.delegate = self;
    self.goButton.enabled = NO;

    [self setUIElements];

}

-(BOOL)shouldAutorotate{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.datahandler.delegate = self;

    [self animationOnReturningToVC];
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

    self.goButton.backgroundColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
    self.goButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.goButton.hidden = YES;

    self.passcodeTextField.hidden = YES;
    self.passcodeTextField.text = @"";
    self.passcodeTextField.layer.borderWidth = 1.0f;
    self.passcodeTextField.layer.borderColor = [[UIColor whiteColor] CGColor];
}

-(void)setUIElementsAfterReturnAnimation {
    self.joinOneButton.hidden = NO;
    self.joinOneButton.enabled = YES;
}

-(void)animationsOfUIElements {

    //animation for JoinButton
    POPSpringAnimation *joinAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    joinAnimation.springSpeed = 20.0f;
    joinAnimation.springBounciness = 5.0f;
    joinAnimation.toValue = @(-83); //-20
    joinAnimation.delegate = self;
    joinAnimation.removedOnCompletion = YES;
    [self.joinConstraint pop_addAnimation:joinAnimation forKey:@"joinButtonAnime"];
    self.joinOneButton.enabled = NO;
    self.joinOneButton.hidden = YES;

    //animation for createButton
    POPSpringAnimation *createAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    createAnimation.springSpeed = 20.0f;
    createAnimation.springBounciness = 5.0f;
    createAnimation.toValue = @(100);
    createAnimation.removedOnCompletion = YES;
    [self.createConstrain pop_addAnimation:createAnimation forKey:@"createButtonAnime"];

    //animation for goButton
    self.goButton.hidden = NO;
    POPSpringAnimation *goAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    goAnimation.springSpeed = 20.0f;
    goAnimation.springBounciness = 5.0f;
    goAnimation.toValue = @(-20); //80
    goAnimation.removedOnCompletion = YES;
    [self.goConstraint pop_addAnimation:goAnimation forKey:@"goButtonAnime"];

    //animation for passcodeTextField
    POPSpringAnimation *animatePasscodeTextField = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animatePasscodeTextField.springBounciness = 0;
    animatePasscodeTextField.springSpeed = 2;
    animatePasscodeTextField.toValue = @(self.passcodeTextField.center.y - 0);
    animatePasscodeTextField.removedOnCompletion = YES;
    [self.passcodeTextField pop_addAnimation:animatePasscodeTextField forKey:@"positionY"];
    self.passcodeTextField.hidden = NO;

}

-(void)animationOnReturningToVC {
    //animation for JoinButton
    POPSpringAnimation *joinAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    joinAnimation.springSpeed = 20.0f;
    joinAnimation.springBounciness = 5.0f;
    joinAnimation.toValue = @(5); //-20
    joinAnimation.delegate = self;
    joinAnimation.removedOnCompletion = YES;
    [self.joinConstraint pop_addAnimation:joinAnimation forKey:@"joinButtonAnime"];

    //animation for createButton
    POPSpringAnimation *createAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    createAnimation.springSpeed = 20.0f;
    createAnimation.springBounciness = 5.0f;
    createAnimation.toValue = @(85);
    createAnimation.removedOnCompletion = YES;
    [self.createConstrain pop_addAnimation:createAnimation forKey:@"createButtonAnime"];
    [self setUIElementsAfterReturnAnimation];
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





#pragma mark -- Data and Segues --

- (void)dataDownloaded {
    [self.spinner stopAnimating];
    self.spinner.hidden=YES;
    [self performSegueWithIdentifier:@"slideshowVCfromJoinVC" sender:self];
}
-(void)wrongPasscode{
    [self.spinner stopAnimating];
    self.spinner.hidden = YES;
    self.passcodeTextField.text = @"Wrong Passcode";
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
    [self.passcodeTextField endEditing:YES];
    [self animationOnReturningToVC];
    [self.passcodeTextField resignFirstResponder];
    [self setUIElements];
}
- (IBAction)textfieldChangedValue:(UITextField *)sender forEvent:(UIEvent *)event {
    if (sender.text.length > 0) {
        self.goButton.enabled = YES;
    }
    else if (sender.text.length == 0) {
        self.goButton.enabled = NO;
    }
}

- (void)updatePage:(int)pageNr{

}

@end
