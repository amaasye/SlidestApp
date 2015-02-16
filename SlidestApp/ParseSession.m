//
//  ParseSession.m
//  SlidestApp
//
//  Created by Matt on 2/14/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "ParseSession.h"
#import <Parse/Parse.h>

@implementation ParseSession
-(void)startConnectivity:(NSString*)passcode{
    self.page = [PFObject objectWithClassName:@"Session"];
    self.page[@"pageNr"] = [NSNumber numberWithInt:0];
    self.page[@"passcode"] = passcode;
    [self.page saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Saved! %@", error);
    }];

}
-(void)updatePageWithNr:(int)pageNr{
    PFQuery *query = [PFQuery queryWithClassName:@"Session"];

    [query getObjectInBackgroundWithId:self.page.objectId block:^(PFObject *session, NSError *error) {

        self.page[@"pageNr"] = [NSNumber numberWithInt:pageNr];
        [session saveInBackground];
        NSLog(@"%d",pageNr);

    }];
   }
     
-(void)getPageWithPasscode:(NSString*)passcode{
    PFQuery *query = [PFQuery queryWithClassName:@"Session"];
    [query whereKey:@"passcode" equalTo:passcode];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                int pageNr = [[object objectForKey:@"pageNr"] intValue];
                NSLog(@"%d", pageNr);
                [self.delegate updateCollecionViewPage:pageNr];
            }
        }
    }];

}
-(void)deleteSession{
    
}
@end
