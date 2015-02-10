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


@interface CreateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *slideshowTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onUploadButtonTapped:(UIButton *)sender {
    [[DBChooser defaultChooser] openChooserForLinkType:DBChooserLinkTypePreview
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
    NSURLRequest *request = [NSURLRequest requestWithURL:chooser.link];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.dataFromDropbox = data;

        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        documentsURL = [documentsURL URLByAppendingPathComponent:@"pdf.pdf"];

        [data writeToURL:documentsURL atomically:YES];


        self.name = chooser.name;
        self.passcode = self.passcodeTextField.text;
        [self pushDataToParse];
    }];
}

- (void)pushDataToParse {

    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    documentsURL = [documentsURL URLByAppendingPathComponent:@"pdf.pdf"];
    NSData *data = [NSData dataWithContentsOfURL:documentsURL];
    PFObject *slideshow = [PFObject objectWithClassName:@"Slideshow"];
    PFFile *file = [PFFile fileWithData:data contentType:@"pdf"];
    slideshow[@"pdf"] = file;
    slideshow[@"titleOfSlideshow"] = self.name;
    slideshow[@"passcode"] = self.passcode;
    [slideshow saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Saved! %@", error);
    }];
}
-(IBAction)unwind:(id)sender{
    
}


@end
