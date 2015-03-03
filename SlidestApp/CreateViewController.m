//
//  CreateViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/9/15.
//  Copyright (c) 2015 Mateusz Pis, Syed Amaanullah and David Miller. All rights reserved.
//

#import "CreateViewController.h"
#import <DBChooser/DBChooser.h>
#import "DataHandler.h"
#import "SessionStatusViewController.h"
#import "POP/POP.h"
#import <QuartzCore/QuartzCore.h>


@interface CreateViewController () <DataHandlerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *uploadFromDropboxButton;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property DataHandler *dataHandler;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *topViewLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *horizontalLine;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataHandler = [DataHandler new];
    self.passcodeTextField.delegate = self;
    [self setUIElements];
    [self animateDropboxLogo];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}
-(void)viewDidAppear:(BOOL)animated{
    
//    [self animateTopAndBottom];
     [super viewDidAppear:YES];
    self.dataHandler.delegate = self;
    self.startButton.enabled = NO;
    [self openDropboxChooser];

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

#pragma mark -- UI and Animations

-(void)setUIElements {
    self.navigationController.navigationBar.hidden = YES;
    self.topViewLabel.hidden = NO;
    self.topViewLabel.text = @"Choose your File";
    self.horizontalLine.hidden = YES;
    self.backgroundView.hidden = YES;
    self.passcodeTextField.hidden = YES;
    self.reminderLabel.hidden = YES;
    self.startButton.hidden = YES;
    self.spinner.hidden = YES;
    self.titleLabel.hidden = YES;
    self.backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.topView.backgroundColor = [UIColor colorWithRed:34/255.0f green:167/255.0f blue:240/255.0f alpha:1.0f];
    self.uploadFromDropboxButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.uploadFromDropboxButton.backgroundColor =[UIColor colorWithRed:34/255.0f green:167/255.0f blue:240/255.0f alpha:1.0f];
    self.startButton.backgroundColor =[UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
    self.startButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}

-(void)setUIElementsAfterFileDownloaded {
    self.reminderLabel.hidden = NO;
    self.reminderLabel.numberOfLines = 0;
    self.backgroundView.hidden = NO;
    self.horizontalLine.hidden = NO;
    self.topViewLabel.hidden = NO;
    self.logoImageView.hidden = YES;
    self.topViewLabel.text = @"Presentation is Ready";
    [self.reminderLabel sizeToFit];
    [self.reminderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.titleLabel.hidden = NO;
    self.titleLabel.backgroundColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
    self.passcodeTextField.hidden = NO;
    self.passcodeTextField.backgroundColor = [UIColor clearColor];
    self.uploadFromDropboxButton.hidden = YES;
    self.startButton.hidden = NO;
}

-(void)animateStartButton {
    POPSpringAnimation *animate = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animate.springBounciness = 0;
    animate.springSpeed = 15;
    animate.toValue = @(self.startButton.center.y - 265);//245
    [self.startButton pop_addAnimation:animate forKey:@"pop"];
}

-(void)animateTopAndBottom {
    POPSpringAnimation *animateTopView = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animateTopView.springBounciness = 0;
    animateTopView.springSpeed = 15;
    animateTopView.toValue = @(self.topView.center.y - 265);
    [self.topView pop_addAnimation:animateTopView forKey:@"pop"];

    POPSpringAnimation *animateTopLabel = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animateTopLabel.springBounciness = 0;
    animateTopLabel.springSpeed = 15;
    animateTopLabel.toValue = @(self.topViewLabel.center.y - 265);
    [self.topViewLabel pop_addAnimation:animateTopLabel forKey:@"pop"];

    POPSpringAnimation *animateBottom = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animateBottom.springBounciness = 0;
    animateBottom.springSpeed = 15;
    animateBottom.toValue = @(self.uploadFromDropboxButton.center.y + 235);
    [self.uploadFromDropboxButton pop_addAnimation:animateBottom forKey:@"pop"];
}

-(void)animateDropboxLogo {
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.duration = 7.0;
    opacityAnimation.fromValue = @(0);
    opacityAnimation.toValue = @(1);
    [self.logoImageView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

- (IBAction)onUploadButtonTapped:(UIButton *)sender {
    [self openDropboxChooser];
}
- (IBAction)onLogoTapped:(UITapGestureRecognizer *)sender {
    [self openDropboxChooser];
}

-(void)openDropboxChooser {
    [[DBChooser defaultChooser] openChooserForLinkType:DBChooserLinkTypeDirect
                                    fromViewController:self completion:^(NSArray *results)
     {
         if ([results count]) {
             DBChooserResult *chooser = results.firstObject;
             [self.dataHandler downloadPDF:chooser];
         } else {
             // User canceled the action
         }
     }];
}

#pragma mark -- Data

- (void)downloadingShouldStart {
    self.uploadFromDropboxButton.hidden = YES;
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
}

- (void)downloadingShouldEnd {
    [self.spinner stopAnimating];
    self.spinner.hidesWhenStopped = YES;
}

-(void)dataShouldUpload{
    [self.spinner stopAnimating];
    [self performSegueWithIdentifier:@"toSession" sender:self];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.startButton.hidden = NO;
    [self animateStartButton];
}
- (IBAction)editingDidChanged:(UITextField*)sender {
    if (sender.text.length > 0) {
        self.startButton.enabled = YES;
    }
    else if (sender.text.length == 0) {
        self.startButton.enabled = NO;
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField {

}

- (void)fileIsPDF:(BOOL)isPDF withName:(NSString *)name {
    if (isPDF) {
        self.reminderLabel.text = name;
        self.name = name;
        [self setUIElementsAfterFileDownloaded];
    } else {
        self.reminderLabel.text = name;
        self.reminderLabel.hidden = NO;
        self.uploadFromDropboxButton.hidden = NO;
    }
}

- (IBAction)onStartButtonTapped:(UIButton *)sender {
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    [self.dataHandler pushDataToDataBase:self.passcodeTextField.text];
    [self.passcodeTextField resignFirstResponder];
}

#pragma mark -- Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"toSession"]){

        SessionStatusViewController *vc = [segue destinationViewController];
        vc.dataHandler = self.dataHandler;
        vc.name = self.name;
    }
}

-(IBAction)unwindToCreateViewController:(UIStoryboardSegue *)sender{
   /// [self.dataHandler deleteFile];
}


#pragma mark -- Alerts

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
@end
