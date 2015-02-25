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


@interface SessionStatusViewController ()<DataHandlerDelegate>
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
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.dataHandler.delegate = self;
    [self.dataHandler listenAudienceNr];

}
-(BOOL)shouldAutorotate{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
-(void)updateAudienceNr:(int)nr{
    self.peerCounterLabel.text = [NSString stringWithFormat:@"%d", nr];
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
        SlideshowViewController *vc = [segue destinationViewController];
        vc.dataHandler = self.dataHandler;
        vc.presenter = YES;
    }
}


- (void)updatePage:(int)pageNr{

}



-(IBAction)unwindToSessionStatusViewController:(UIStoryboardSegue *)sender{

}

@end
