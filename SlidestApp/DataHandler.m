//
//  DataHandler.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/13/15.
//  Copyright (c) 2015 Mateusz Pis, Syed Amaanullah and David Miller. All rights reserved.
//

#import "DataHandler.h"


@implementation DataHandler


- (void)downloadPDF:(DBChooserResult *)chooser {
    [self.delegate downloadingShouldStart];
    NSURLRequest *request = [NSURLRequest requestWithURL:chooser.link];
    NSLog(@"%@",chooser.link);
    self.link = [NSString stringWithFormat:@"%@", chooser.link];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSLog(@"%lld",[response expectedContentLength]);

        if (!connectionError) {
        self.dataFromDropbox = data;

        [self.delegate downloadingShouldEnd];
        [self checkFileType:chooser.name];
        }
        else {
            [self connectionProblem:@"There was an error in completing this request"];
        }
    }];
}

- (void)checkFileType:(NSString *)name {
    if ([name hasSuffix:@"pdf"]) {
        [self.delegate fileIsPDF:YES withName:name];
        self.name = name;
    }
    else {
        [self.delegate fileIsPDF:NO withName:@"File type is not supported"];
    }
}

-(void)downloadPDFFromLink:(NSString*)passcode{
    self.passcode = passcode;

    NSString *urlString = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@/basic",self.passcode];
    Firebase *ref = [[Firebase alloc] initWithUrl:urlString];

    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {

        if (snapshot.exists)  {
            [self runConnection:snapshot.value[@"link"]];
                   }
        else{

        }

    } withCancelBlock:^(NSError *error) {
        [self connectionProblem:@"There was a problem in completing this request"];
        NSLog(@"%@", error.description);
    }];
}
-(void)runConnection:(NSString*)url{
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSLog(@"%lld",[response expectedContentLength]);

        if (!connectionError) {
            self.dataFromDropbox = data;

            [self.delegate dataDownloaded];

        }
        else {
            [self connectionProblem:@"There was an error in completing this request"];
        }
    }];



}
- (void)pushDataToDataBase:(NSString *)passcode {


    self.passcode = passcode;
    Firebase *ref = [[Firebase alloc ]initWithUrl:@"https://brilliant-fire-3573.firebaseio.com/"];
    NSString *pdfData = [self.dataFromDropbox base64EncodedStringWithOptions:0];

    NSDictionary *basic = @{
                                @"name": self.name,
                                @"data": [self validateData:pdfData],
                                @"passcode": self.passcode,
                                @"link": self.link,
                                                                };
    NSDictionary *currentPage = @{
                                  @"currentPage": [NSNumber numberWithInt:0],
                                  };
    NSDictionary *audienceNr = @{
                                 @"audienceNr": [NSNumber numberWithInt:0],
                                 };
    NSDictionary *drawPoints = @{
                                 @"drawPointX": [NSNumber numberWithInt:0],
                                 @"drawPointY": [NSNumber numberWithInt:0],
                                 @"color": @"black",

                                 };

    NSDictionary *slideshow = @{
                                @"basic": basic,
                                @"currentPage": currentPage,
                                @"audienceNr": audienceNr,
                                @"drawPoints": drawPoints,

                                };
    Firebase *slideshowRef = [ref childByAppendingPath: self.passcode];

    [slideshowRef setValue:slideshow withCompletionBlock:^(NSError *error, Firebase *ref) {
        if(!error){
            [self.delegate dataShouldUpload];
        }
        else {
            [self connectionProblem:@"There was a problem in completing this request"];
        }
    }];

}
-(NSString*)validateData:(NSString*)data{
    NSLog(@"%@",data);
    if (data.length >7999999) {
        return @"";
    }
    else{
        return data;
    }
}
- (void)setPage:(int)pageNr{
    NSString *url = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@",self.passcode];
    
    Firebase *ref= [[Firebase alloc ]initWithUrl:url];


    NSDictionary *slideshow = @{

                                @"currentPage": [NSNumber numberWithInt:pageNr],
                                };

    Firebase *slideshowRef = [ref childByAppendingPath: @"currentPage"];
    [slideshowRef updateChildValues: slideshow];
    self.pageNr = pageNr;
    [self setPageAtWatch:pageNr];

}

-(void)pullFromDataBase:(NSString *)passcode {

    self.passcode = passcode;

    NSString *urlString = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@/basic",self.passcode];
    Firebase *ref = [[Firebase alloc] initWithUrl:urlString];

    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {

        if (snapshot.exists)  {

            self.dataFromDropbox = [[NSData alloc] initWithBase64EncodedString:snapshot.value[@"data"] options:0];
        
            [self.delegate dataDownloaded];
        }
        else{

        }

    } withCancelBlock:^(NSError *error) {
        [self connectionProblem:@"There was a problem in completing this request"];
        NSLog(@"%@", error.description);
    }];

}
-(void)checkPage{

    NSString *urlString = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@/currentPage",self.passcode];
    Firebase *ref = [[Firebase alloc] initWithUrl:urlString];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.exists) {

        [self.delegate updatePage: [snapshot.value[@"currentPage"] intValue]];
        //NSLog(@"%@", snapshot.value[@"currentPage"]);
        }
         }];
}
-(void)deleteFile{
    
    NSString *urlString = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@",self.passcode];
    Firebase *ref = [[Firebase alloc] initWithUrl:urlString];
    [ref removeValue];

    self.dataFromDropbox = nil;
    self.passcode = nil;
    [self deactivateWatchApp];
}
-(void)listenAudienceNr{
    
    NSString *urlString = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@/audienceNr",self.passcode];
    Firebase *ref = [[Firebase alloc] initWithUrl:urlString];

    [ref observeEventType:FEventTypeValue andPreviousSiblingKeyWithBlock:^(FDataSnapshot *snapshot, NSString *prevKey) {
        if(self.dataFromDropbox != nil){

        [self.delegate  updateAudienceNr:[snapshot.value[@"audienceNr"] intValue]];
        }
    }];

}
-(void)checkAudienceNumber{
    NSString *urlString = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@/audienceNr",self.passcode];
    Firebase *ref = [[Firebase alloc] initWithUrl:urlString];

    [ref observeSingleEventOfType:FEventTypeValue andPreviousSiblingKeyWithBlock:^(FDataSnapshot *snapshot, NSString *prevKey) {
        [self updateAudienceNumber:[snapshot.value[@"audienceNr"] intValue]];
    }];

}
-(void)updateAudienceNumber:(int)nr{
    NSString *urlString = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@",self.passcode];
    Firebase *ref = [[Firebase alloc] initWithUrl:urlString];

    NSDictionary *slideshow = @{

                                @"audienceNr": [NSNumber numberWithInt:(nr+1)],

                                };

    Firebase *slideshowRef = [ref childByAppendingPath: @"audienceNr"];
    [slideshowRef updateChildValues: slideshow];


}
-(void)updateDrawPosition:(CGPoint)point withColor:(NSString*)color{

    NSString *urlString = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@",self.passcode];
    Firebase *ref = [[Firebase alloc] initWithUrl:urlString];

    NSDictionary *slideshow = @{

                                @"drawPointX": [NSNumber numberWithInt:point.x],
                                @"drawPointY": [NSNumber numberWithInt:point.y],
                                @"color": color,

                                };

    Firebase *slideshowRef = [ref childByAppendingPath: @"drawPoints"];
    [slideshowRef updateChildValues: slideshow];
    
}
-(void)observeDrawPosition{
    NSString *urlString = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@/drawPoints",self.passcode];
    Firebase *ref = [[Firebase alloc] initWithUrl:urlString];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.exists) {

            [self.delegate drawGestureWithpoint:CGPointMake([snapshot.value[@"drawPointX"] intValue], [snapshot.value[@"drawPointY"] intValue]) andColor:snapshot.value[@"color"]];
        }
    }];

    
    
}

-(void)canUserSwipe:(BOOL)canSwipe{
    NSString *urlString = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@",self.passcode];
    Firebase *ref = [[Firebase alloc] initWithUrl:urlString];

    NSDictionary *slideshow = @{

                                @"canSwipe": [NSNumber numberWithBool:canSwipe],
                                };

    Firebase *slideshowRef = [ref childByAppendingPath: @"userSettings"];
    [slideshowRef updateChildValues: slideshow];

}

-(void)canUserSave:(BOOL)canSave{
    NSString *urlString = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@",self.passcode];
    Firebase *ref = [[Firebase alloc] initWithUrl:urlString];

    NSDictionary *slideshow = @{

                                @"canSave": [NSNumber numberWithBool:canSave],
                                };

    Firebase *slideshowRef = [ref childByAppendingPath: @"userSettings"];
    [slideshowRef updateChildValues: slideshow];
    
}
-(void)listenUserSettings{
    NSString *urlString = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@/userSettings",self.passcode];
    Firebase *ref = [[Firebase alloc] initWithUrl:urlString];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.exists) {
            NSNumber *userCanSwipe = snapshot.valueInExportFormat[@"canSwipe"];
            NSNumber *userCanSave = snapshot.valueInExportFormat[@"canSave"];

            [self.delegate userSettingsShouldChange:[userCanSwipe boolValue] andCanSave:[userCanSave boolValue]];
        }
    }];


}
#pragma mark alertViews

-(void)connectionProblem:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark applewatch comminication

-(void)setPageAtWatch:(int)number{

    NSUserDefaults *defaults = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.Matt"];

    [defaults setInteger:number forKey:@"pageNr"];
    [defaults setBool:YES forKey:@"isPresentation"];
    [defaults setInteger:self.totalPages forKey:@"totalPages"];

    [defaults synchronize];

    NSLog(@"Watchkit app has nr: %d",number);

}
-(void)deactivateWatchApp{
    
    NSUserDefaults *defaults = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.Matt"];

    [defaults setBool:NO forKey:@"isPresentation"];
    [defaults setInteger:0 forKey:@"pageNr"];

    [defaults synchronize];

}
-(NSString*)pdfString{
    return @"";
}
-(NSString*)savePDFAndReturnPath{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *dirctryForSaving = paths.firstObject;

    NSString *saveFileName = @"File.pdf";

    NSString *newFilePath = [dirctryForSaving stringByAppendingPathComponent:saveFileName];

    [self.dataFromDropbox writeToFile:newFilePath atomically:YES];

    NSLog(@"%@", newFilePath);
    return newFilePath;
}
@end
