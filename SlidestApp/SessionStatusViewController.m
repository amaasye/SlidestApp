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
#import "POP/POP.h"


@interface SessionStatusViewController ()<DataHandlerDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *sessionTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *goToSlideshowButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelSlideshowButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIView *greenLine;
@property (weak, nonatomic) IBOutlet UILabel *peerCounterLabel;
@end

@implementation SessionStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUIElements];

   // [self animateGreenLine];
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
    self.titleLabel.text = self.name;
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel sizeToFit];
    [self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.topView.backgroundColor = [UIColor colorWithRed:34/255.0f green:167/255.0f blue:240/255.0f alpha:1.0f];
    self.goToSlideshowButton.backgroundColor =[UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
    self.goToSlideshowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.cancelSlideshowButton.backgroundColor =[UIColor colorWithRed:34/255.0f green:167/255.0f blue:240/255.0f alpha:1.0f];
    self.cancelSlideshowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}

//-(void)animateGreenLine {
//    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
//    opacityAnimation.duration = 3.0;
//    opacityAnimation.fromValue = @(0);
//    opacityAnimation.toValue = @(1);
//    [self.greenLine.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
//}

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
