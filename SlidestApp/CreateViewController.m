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
//#import "CustomSegue.h"
//#import "CustomUnwindSegue.h"

@interface CreateViewController () <DataHandlerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *uploadFromDropboxButton;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *getSlideshowLabel;
@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property DataHandler *dataHandler;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

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
    self.dataHandler.delegate = self;

}

#pragma mark -- UI and Animations

-(void)setUIElements {
    self.navigationController.navigationBar.hidden = YES;
    self.passcodeTextField.hidden = YES;
    self.reminderLabel.hidden = YES;
    self.startButton.hidden = YES;
    self.spinner.hidden = YES;
    self.backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.topView.backgroundColor = [UIColor colorWithRed:34/255.0f green:167/255.0f blue:240/255.0f alpha:1.0f];
    self.getSlideshowLabel.textColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
    self.startButton.backgroundColor =[UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
    self.startButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}

-(void)animateButton {
    POPSpringAnimation *animate = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animate.springBounciness = 0;
    animate.springSpeed = 15;
    animate.toValue = @(self.startButton.center.y - 215);
    [self.startButton pop_addAnimation:animate forKey:@"pop"];
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

- (void)fileIsPDF:(BOOL)isPDF withName:(NSString *)name {
    if (isPDF) {
        self.reminderLabel.text = name;
        self.reminderLabel.hidden = NO;
        self.reminderLabel.numberOfLines = 0;
        [self.reminderLabel sizeToFit];
        [self.reminderLabel setLineBreakMode:NSLineBreakByWordWrapping];
        self.passcodeTextField.hidden = NO;
        self.uploadFromDropboxButton.hidden = YES;
        self.getSlideshowLabel.hidden = YES;
        self.startButton.hidden = NO;

    } else {

        self.reminderLabel.text = name;
        self.reminderLabel.hidden = NO;
        self.uploadFromDropboxButton.hidden = NO;
    }
}

- (IBAction)onStartButtonTapped:(UIButton *)sender {

    self.startButton.hidden = YES;
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    [self.dataHandler pushDataToDataBase:self.passcodeTextField.text];
    [self.passcodeTextField resignFirstResponder];
}

#pragma mark -- Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"toSession"]){
//        ((CustomSegue *)segue).originatingPoint = self.passcodeTextField.center;

        SessionStatusViewController *vc = [segue destinationViewController];
        vc.dataHandler = self.dataHandler;
    }
}

//- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
//    // Instantiate a new CustomUnwindSegue
//    CustomUnwindSegue *segue = [[CustomUnwindSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
//    // Set the target point for the animation to the center of the button in this VC
//    segue.targetPoint = self.passcodeTextField.center;
//    return segue;
//}

-(IBAction)unwindToCreateViewController:(UIStoryboardSegue *)sender{
    [self.dataHandler deleteFile];
}


#pragma mark -- Alerts

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
@end
