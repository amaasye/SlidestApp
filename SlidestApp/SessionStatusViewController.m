//
//  SessionStatusViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/11/15.
//  Copyright (c) 2015 Mateusz Pis, Syed Amaanullah and David Miller. All rights reserved.
//

#import "SessionStatusViewController.h"
#import "SlideshowViewController.h"
#import "DataHandler.h"


@interface SessionStatusViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *sessionTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *goToSlideshowButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelSlideshowButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *peerCounterLabel;
@end

@implementation SessionStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUIElements];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
}

-(void)setUIElements {
    self.navigationController.navigationBar.hidden = YES;
    self.backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.topView.backgroundColor = [UIColor colorWithRed:34/255.0f green:167/255.0f blue:240/255.0f alpha:1.0f];
    self.goToSlideshowButton.backgroundColor =[UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
    self.goToSlideshowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.cancelSlideshowButton.backgroundColor =[UIColor colorWithRed:34/255.0f green:167/255.0f blue:240/255.0f alpha:1.0f];
    self.cancelSlideshowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}


- (IBAction)onEndSessionButtonTapped:(UIButton *)sender {
    [self.dataHandler deleteFile];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ToSlideshow"]){
//        ((CustomSegue *)segue).originatingPoint = self.goToSlideshowButton.center;
        SlideshowViewController *vc = [segue destinationViewController];
        vc.dataHandler = self.dataHandler;
        vc.presenter = YES;
    }
}

//- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
//    // Instantiate a new CustomUnwindSegue
//    CustomUnwindSegue *segue = [[CustomUnwindSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
//    // Set the target point for the animation to the center of the button in this VC
//    segue.targetPoint = self.goToSlideshowButton.center;
//    return segue;
//}

-(IBAction)unwindToSessionStatusViewController:(UIStoryboardSegue *)sender{

}

@end
