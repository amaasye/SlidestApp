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
#import "SlideshowViewController.h"


@interface CreateViewController ()
@property (weak, nonatomic) IBOutlet UIButton *uploadFromDropboxButton;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;

@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *horizontalLine;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property PFObject *slideshow;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
             [self downloadPDF:chooser];
         } else {
             // User canceled the action
         }
     }];

}

- (void)downloadPDF:(DBChooserResult *)chooser {
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:chooser.link];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.dataFromDropbox = data;

        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        documentsURL = [documentsURL URLByAppendingPathComponent:@"pdf.pdf"];

        [data writeToURL:documentsURL atomically:YES];

        self.name = chooser.name;
        self.passcode = self.passcodeTextField.text;
        [self.spinner stopAnimating];
        self.spinner.hidesWhenStopped = YES;
        //checks to see if the file is a pdf and only saves it if it is, adjusts layout accordingly
        [self checkForFileType];
    }];
}

- (void)checkForFileType {
        //file is pdf
    if ([self.name hasSuffix:@"pdf"]) {
        self.reminderLabel.text = self.name;
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
        self.reminderLabel.hidden = NO;
        self.horizontalLine.hidden = NO;
    }
}

- (IBAction)onStartButtonTapped:(UIButton *)sender {
    self.passcode = self.passcodeTextField.text;
    [self pushDataToParse];
}

- (IBAction)onEndButtonTapped:(UIButton *)sender {
    [self.slideshow deleteInBackground];
    [self.slideshow unpin];
    [self viewDidLoad];
}


- (void)pushDataToParse {

    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    documentsURL = [documentsURL URLByAppendingPathComponent:@"pdf.pdf"];
    NSData *data = [NSData dataWithContentsOfURL:documentsURL];
    self.slideshow = [PFObject objectWithClassName:@"Slideshow"];
    PFFile *file = [PFFile fileWithData:data contentType:@"pdf"];
    self.slideshow[@"pdf"] = file;
    self.slideshow[@"titleOfSlideshow"] = self.name;
    self.slideshow[@"passcode"] = self.passcode;
    [self.slideshow saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Saved! %@", error);
    }];

}

-(IBAction)unwindToCreateViewController:(UIStoryboardSegue *)sender{
    
}


@end
