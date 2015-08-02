//
//  RootInterfaceController.m
//  SlidestApp
//
//  Created by Matt on 7/28/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "RootInterfaceController.h"
@interface RootInterfaceController (){
    BOOL isActive;
}
@property NSUserDefaults *defaults;

@end

@implementation RootInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.defaults = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.Matt"];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];

    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self selector:@selector(listenForActiveSlideshow) userInfo:nil repeats:YES];
}
-(void)listenForActiveSlideshow{

    isActive = [self.defaults boolForKey:@"isPresentation"];

    if (isActive) {
        [self presentControllerWithName:@"Slideo" context:nil];
    }
}
- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



