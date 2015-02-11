//
//  JoinViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/9/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "JoinViewController.h"
#import <Parse/Parse.h>

@interface JoinViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;


@end

@implementation JoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)onGoButtonTapped:(UIButton *)sender {
    [self parseQuery];
}

-(void)parseQuery {
    PFQuery *query = [PFQuery queryWithClassName:@"Slideshow"];
    [query whereKey:@"passcode" equalTo:self.passcodeTextField.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Found something...
            NSLog(@"Successfully retrieved %lu slideshow.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                [object pinInBackground];
                self.object = object;
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}



@end
