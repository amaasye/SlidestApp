//
//  ViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/9/15.
//  Copyright (c) 2015 Mateusz Pis, Syed Amaanullah and David Miller. All rights reserved.
//

#import "RootViewController.h"
#import "SlideshowViewController.h"
#import "DataHandler.h"
#import <QuartzCore/QuartzCore.h>

@interface RootViewController () <DataHandlerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *createSlideshowButton;
@property (weak, nonatomic) IBOutlet UIButton *joinOneButton;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *joinConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *createConstrain;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *goConstraint;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.passcodeTextField.delegate = self;
    self.goButton.enabled = YES;
    self.navigationController.navigationBar.hidden = YES;
    [self.datahandler deactivateWatchApp];
    self.spinner.hidden = YES;
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.datahandler = [DataHandler new];
    self.datahandler.delegate = self;


}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.passcodeTextField.text = @"ENTER PASSCODE ";
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.passcodeTextField resignFirstResponder];

}
#pragma mark -- Actions --


- (IBAction)onGoButtonTapped:(UIButton *)sender {
    [self startConnection];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self startConnection];
    return YES;
}



#pragma mark -- Data and Segues --
-(void)startConnection{
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    [self.datahandler downloadPDFFromLink:self.passcodeTextField.text];
   // [self.datahandler pullFromDataBase:self.passcodeTextField.text];
    [self.passcodeTextField resignFirstResponder];
}
- (void)dataDownloaded {
    [self.spinner stopAnimating];
    self.spinner.hidden=YES;
    [self performSegueWithIdentifier:@"slideshowVCfromJoinVC" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([[segue identifier] isEqualToString:@"toCreate"]) {
    }
    else if ([[segue identifier] isEqualToString:@"slideshowVCfromJoinVC"]){
        SlideshowViewController *svc = [segue destinationViewController];
                   svc.dataHandler = self.datahandler;
        svc.presenter = NO;
    }
}


-(IBAction)unwind:(UIStoryboardSegue *)segue {
    [self.passcodeTextField endEditing:YES];
    [self.passcodeTextField resignFirstResponder];
}

- (void)updatePage:(int)pageNr{

}

@end
