//
//  ParseSession.h
//  SlidestApp
//
//  Created by Matt on 2/14/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ParseSessionDelegate
@optional
-(void)updateCollecionViewPage:(int)pageNr;
@end

@interface ParseSession : NSObject
@property id<ParseSessionDelegate>delegate;
-(void)startConnectivity:(NSString*)passcode;
-(void)updatePageWithNr:(int)pageNr;
-(void)getPageWithPasscode:(NSString*)passcode;
@end
