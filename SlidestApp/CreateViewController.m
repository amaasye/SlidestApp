//
//  CreateViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/9/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "CreateViewController.h"
#import <DBChooser/DBChooser.h>


@interface CreateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleOfSlideshowTextField;

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
    }];
}



@end
