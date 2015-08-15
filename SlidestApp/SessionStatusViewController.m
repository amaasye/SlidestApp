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
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *peerCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *passcode;
@property (strong, nonatomic) IBOutlet UISwitch *canSwipeSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *canSaveSwitch;


@end

@implementation SessionStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUIElements];
    self.dataHandler.delegate = self;
    [self.dataHandler canUserSave:NO];
    [self.dataHandler canUserSwipe:NO];
   // [self animateGreenLine];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.dataHandler.delegate = self;
    [self.dataHandler listenAudienceNr];


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
    self.passcode.text = self.dataHandler.passcode;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ToSlideshow"]){
        SlideshowViewController *vc = [segue destinationViewController];
        vc.dataHandler = self.dataHandler;
        vc.presenter = YES;
    }
    else{
        [self.dataHandler deleteFile];
    }
}
- (void)updatePage:(int)pageNr{

}
#pragma mark actions
- (IBAction)canSwipeChanged:(UISwitch *)sender {
    [self.dataHandler canUserSwipe:self.canSwipeSwitch.on];
}

- (IBAction)canSaveChanged:(id)sender {
    [self.dataHandler canUserSave:self.canSaveSwitch.on];
}



@end
