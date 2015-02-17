//
//  ParseSession.m
//  SlidestApp
//
//  Created by Matt on 2/14/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "ParseSession.h"


@implementation ParseSession
-(void)startConnectivity:(NSString*)passcode{

}

-(void)updatePageWithNr:(int)pageNr{
}
     
-(void)getPageWithPasscode:(NSString*)passcode{

    [self.delegate updateCollecionViewPage:1];

}
-(void)deleteSession{
    
}
@end
