//
//  InterfaceController.m
//  Slideo WatchKit Extension
//
//  Created by Matt on 7/12/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController(){
    BOOL isActive;
    int upcomingNumber;
    int currentNumber;
    int totalPageNumber;
}
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *pageNumberLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *totalPageNumberLabel;
@property NSUserDefaults *defaults;
@end

//in communication way within this app, currentPage is euqivalent of indexPath to drive collectionView

@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    currentNumber = 1;
    self.defaults = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.Matt"];
    [NSTimer scheduledTimerWithTimeInterval:.2f
                                     target:self selector:@selector(listenForPageAndActivity) userInfo:nil repeats:YES];
    totalPageNumber =(int) [self.defaults integerForKey:@"totalPages"];
    self.totalPageNumberLabel.text = [NSString stringWithFormat:@"%d", totalPageNumber];

    // Configure interface objects here.
}

- (IBAction)forwardButtonTapped {
    if ( currentNumber +1 < totalPageNumber) {
        [self changePageBy:1];
    }

}
- (IBAction)backButtonTapped {
    if (currentNumber> 0){
        [self changePageBy:-1];
    }

}
-(void)changePageBy:(int)number{

    NSLog(@"%d",totalPageNumber);


    int pageNr = (int)[self.defaults integerForKey:@"pageNr"];

    pageNr = pageNr + number;

    NSUserDefaults *defaults = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.Matt"];

    [defaults setInteger:pageNr forKey:@"pageNr"];

    [defaults synchronize];

}

-(void)listenForPageAndActivity{

    upcomingNumber = (int)[self.defaults integerForKey:@"pageNr"];
     isActive = [self.defaults boolForKey:@"isPresentation"];

   if (!isActive) {
        [self dismissController];
    }

    if (currentNumber != upcomingNumber){

       self.pageNumberLabel.text = [NSString stringWithFormat:@"%d",upcomingNumber +1];
       currentNumber = upcomingNumber;
   }

}
- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



