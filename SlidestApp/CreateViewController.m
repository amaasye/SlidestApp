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

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataHandler = [DataHandler new];
    self.passcodeTextField.delegate = self;
    [self setUIElements];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}
-(void)viewDidAppear:(BOOL)animated{
    [self animateDropboxButton];
    self.dataHandler.delegate = self;
    self.startButton.enabled = NO;

}
-(BOOL)shouldAutorotate{
    return NO;
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

-(void)animateButton {
    POPSpringAnimation *animate = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animate.springBounciness = 0;
    animate.springSpeed = 15;
    animate.toValue = @(self.startButton.center.y - 245);
    [self.startButton pop_addAnimation:animate forKey:@"pop"];
}

-(void)animateDropboxButton {
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
//    opacityAnimation.beginTime = CACurrentMediaTime() + .2;
    opacityAnimation.duration = 2.0;
    opacityAnimation.fromValue = @(0);
    opacityAnimation.toValue = @(1);
    [self.uploadFromDropboxButton.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];

    POPSpringAnimation *animateDropbox = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animateDropbox.springBounciness = 0;
    animateDropbox.springSpeed = 15;
    animateDropbox.toValue = @(self.uploadFromDropboxButton.center.y - 215);
    [self.uploadFromDropboxButton pop_addAnimation:animateDropbox forKey:@"pop"];
}

- (IBAction)onUploadButtonTapped:(UIButton *)sender {
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
    [self animateButton];
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
