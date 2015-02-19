//
//  ViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/9/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "RootViewController.h"
#import "SlideshowViewController.h"
#import "POP/POP.h"

@interface RootViewController () <DataHandlerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *createSlideshowButton;
@property (weak, nonatomic) IBOutlet UIButton *joinOneButton;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datahandler = [DataHandler new];
    self.datahandler.delegate = self;
    self.passcodeTextField.hidden = YES;
    self.goButton.hidden = YES;
    [self setUIElements];
}

-(void)setUIElements{
    self.createSlideshowButton.backgroundColor = [UIColor colorWithRed:34/255.0f green:167/255.0f blue:240/255.0f alpha:1.0f];
    self.createSlideshowButton.layer.cornerRadius = 0.f;
    self.createSlideshowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    self.joinOneButton.backgroundColor = [UIColor colorWithRed:34/255.0f green:167/255.0f blue:240/255.0f alpha:1.0f];
    self.joinOneButton.layer.cornerRadius = 0.f;
    self.joinOneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;


    self.goButton.backgroundColor =[UIColor colorWithRed:20/255.0f green:83/255.0f blue:143/255.0f alpha:1.0f];
    self.goButton.layer.cornerRadius = 0.f;
    self.goButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

- (IBAction)onJoinButtonTapped:(UIButton *)sender {
    [self animationsOfUIElements];

}

-(void)animationsOfUIElements {
    POPSpringAnimation *animateJoin = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animateJoin.springBounciness = 0;
    animateJoin.springSpeed = 2;
    animateJoin.toValue = @(self.joinOneButton.center.y + 82);
    [self.joinOneButton pop_addAnimation:animateJoin forKey:@"postionX"];

    POPSpringAnimation *anime = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anime.springBounciness = 0;
    anime.springSpeed = 2;
    anime.toValue = @(self.createSlideshowButton.center.y - 30);
    [self.createSlideshowButton pop_addAnimation:anime forKey:@"pop"];

    self.passcodeTextField.hidden = NO;
    self.goButton.hidden = NO;

    POPSpringAnimation *animateGo = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animateGo.springBounciness = 10;
    animateGo.springSpeed = 10;
    animateGo.toValue = @(self.goButton.center.y - 64);
    [self.goButton pop_addAnimation:animateGo forKey:@"positionY"];
}

- (IBAction)onGoButtonTapped:(UIButton *)sender {
    [self.datahandler pullFromDataBase:self.passcodeTextField.text];
}

- (void)dataDownloaded {
    [self performSegueWithIdentifier:@"slideshowVCfromJoinVC" sender:self];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"slideshowVCfromJoinVC"]){

        SlideshowViewController *svc = [segue destinationViewController];
        svc.dataHandler = self.datahandler;
    }
}


-(IBAction)unwind:(UIStoryboardSegue *)segue {
//    //should delete the file from local storage
//    if ([segue.sourceViewController isKindOfClass:[JoinViewController class]]) {
//        JoinViewController *joinVC = segue.sourceViewController;
//        joinVC.object = self.object;
//        [self.object unpin];
//    }
}



@end
