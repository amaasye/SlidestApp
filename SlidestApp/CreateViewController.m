//
//  CreateViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/9/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "CreateViewController.h"
#import <DBChooser/DBChooser.h>
#import "DataHandler.h"
#import "SessionStatusViewController.h"

@interface CreateViewController () <DataHandlerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *uploadFromDropboxButton;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *getFileFromDropboxLabel;
@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *horizontalLine;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property DataHandler *dataHandler;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataHandler = [DataHandler new];
    self.dataHandler.delegate = self;
    self.passcodeTextField.hidden = YES;
    self.reminderLabel.hidden = YES;
    self.startButton.hidden = YES;
    self.horizontalLine.hidden = NO;
    self.spinner.hidden = YES;
    [self setUIElements];
}

-(void)setUIElements {
    self.topView.backgroundColor = [UIColor colorWithRed:34/255.0f green:167/255.0f blue:240/255.0f alpha:1.0f];
    self.horizontalLine.backgroundColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
    self.getFileFromDropboxLabel.textColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
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
    self.startButton.hidden = NO;
    [self performSegueWithIdentifier:@"toSession" sender:self];


}

- (void)fileIsPDF:(BOOL)isPDF withName:(NSString *)name {
    if (isPDF) {
        self.reminderLabel.text = name;
        self.reminderLabel.hidden = NO;
        [self.reminderLabel sizeToFit];
        self.passcodeTextField.hidden = NO;
        self.uploadFromDropboxButton.hidden = YES;
        self.getFileFromDropboxLabel.hidden = YES;
        self.startButton.hidden = NO;
        self.horizontalLine.hidden = NO;

    } else {

        self.reminderLabel.text = name;
        self.reminderLabel.hidden = NO;
        self.horizontalLine.hidden = NO;
    }
}

- (IBAction)onStartButtonTapped:(UIButton *)sender {

    self.startButton.hidden = YES;
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    [self.dataHandler pushDataToDataBase:self.passcodeTextField.text];
    [self.passcodeTextField resignFirstResponder];
}



-(IBAction)unwindToCreateViewController:(UIStoryboardSegue *)sender{
    [self.dataHandler deleteFile];
    }
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"toSession"]){

    SessionStatusViewController *vc = [segue destinationViewController];
    vc.dataHandler = self.dataHandler;
    }
}

@end
