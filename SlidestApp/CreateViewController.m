//
//  CreateViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/9/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "CreateViewController.h"
#import <DBChooser/DBChooser.h>
#import <Parse/Parse.h>
#import "DataHandler.h"
#import "SessionStatusViewController.h"

@interface CreateViewController () <DataHandlerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *uploadFromDropboxButton;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;

@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *horizontalLine;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property PFObject *slideshow;
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
    self.horizontalLine.hidden = YES;
    self.spinner.hidden = YES;
    self.endButton.hidden = YES;
    
    // Do any additional setup after loading the view.
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
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
}

- (void)downloadingShouldEnd {
    [self.spinner stopAnimating];
    self.spinner.hidesWhenStopped = YES;
}


- (void)fileIsPDF:(BOOL)isPDF withName:(NSString *)name {
    if (isPDF) {
        self.reminderLabel.text = name;
        self.reminderLabel.hidden = NO;
        [self.reminderLabel sizeToFit];
        self.passcodeTextField.hidden = NO;
        self.uploadFromDropboxButton.hidden = YES;
        self.startButton.hidden = NO;
        self.endButton.hidden = NO;
        self.horizontalLine.hidden = NO;
      //  [self pushDataToParse];
    } else {
        //if the file is not a pdf, users are asked to only upload pdf files
        self.reminderLabel.text = name;
        self.reminderLabel.hidden = NO;
        self.horizontalLine.hidden = NO;
    }
}

- (IBAction)onStartButtonTapped:(UIButton *)sender {
//    self.passcode = self.passcodeTextField.text;
    [self.dataHandler pushDataToParse:self.passcodeTextField.text];
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
