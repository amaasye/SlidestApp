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
#import <QuartzCore/QuartzCore.h>


@interface CreateViewController () <DataHandlerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *fileTitle;
@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property DataHandler *dataHandler;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *isReadyLabel;
@property (weak, nonatomic) IBOutlet UILabel *yourFileLabel;
@property (weak, nonatomic) IBOutlet UIView *setLabel;
@property (weak, nonatomic) IBOutlet UILabel *navigationTitleLabel;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataHandler = [DataHandler new];
    self.passcodeTextField.delegate = self;
    [self setUIElements];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [self openDropboxChooser];


}
-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:YES];
    self.dataHandler.delegate = self;
    self.dataHandler.passcode = nil;
    self.dataHandler.dataFromDropbox = nil;

}
-(BOOL)shouldAutorotate{
    return YES;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -- UI and Animations

-(void)setUIElements {

    self.fileTitle.hidden = YES;
    self.spinner.hidden = YES;
    self.yourFileLabel.hidden = YES;
    self.isReadyLabel.hidden = YES;
    self.passcodeTextField.hidden = YES;
    self.setLabel.hidden = YES;
    self.navigationTitleLabel.text = @"GET FILE";

}

-(void)setUIElementsAfterFileDownloaded {
    self.fileTitle.hidden = NO;
    self.fileTitle.numberOfLines = 0;
    self.setLabel.hidden = NO;
    [self.fileTitle sizeToFit];
    [self.fileTitle setLineBreakMode:NSLineBreakByWordWrapping];
    self.yourFileLabel.hidden = NO;
    self.isReadyLabel.hidden = NO;
    self.passcodeTextField.hidden = NO;
    self.setLabel.hidden = NO;
    self.navigationTitleLabel.text = @"FILE IS READY";
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

- (void)fileIsPDF:(BOOL)isPDF withName:(NSString *)name {
    if (isPDF) {
        self.fileTitle.text = name;
        self.name = name;
        [self setUIElementsAfterFileDownloaded];
    } else {
        self.fileTitle.text = name;
        self.fileTitle.hidden = NO;
    }
}

- (void)startSession {
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    [self.dataHandler pushDataToDataBase:self.passcodeTextField.text];
    [self.passcodeTextField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self startSession];
    return YES;
}

#pragma mark -- Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"toSession"]){

        SessionStatusViewController *vc = [segue destinationViewController];
        vc.dataHandler = self.dataHandler;
        vc.name = self.name;
    }

    else {
        [self.dataHandler deleteFile];
    }
}




#pragma mark -- Alerts

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
@end
