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
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
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
    if ([name hasSuffix:@"pdf"] && (self.dataFromDropbox.length <= 10485760)) {
        [self.delegate fileIsPDF:YES withName:name];
        self.name = name;
    }
    else {
        [self.delegate fileIsPDF:NO withName:@"File type is not supported or file is more than 7 MB"];
    }
}

- (void)pushDataToDataBase:(NSString *)passcode {

    self.passcode = passcode;
    self.pdfDataRef = [[Firebase alloc ]initWithUrl:@"https://brilliant-fire-3573.firebaseio.com/"];
    NSString *pdfData = [self.dataFromDropbox base64EncodedStringWithOptions:0];
    NSLog(@"%lu", (unsigned long)self.dataFromDropbox.length);
    //NSData *data = [[NSData alloc] initWithBase64EncodedString:stringForm options:0];


    NSDictionary *slideshow = @{
                                @"name": self.name,
                                @"data": pdfData,
                                @"passcode": self.passcode,
                                @"currentPage": [NSNumber numberWithInt:0],
                                @"audienceNr": [NSNumber numberWithInt:0],
                                };

    Firebase *slideshowRef = [self.pdfDataRef childByAppendingPath: self.passcode];

    [slideshowRef setValue:slideshow withCompletionBlock:^(NSError *error, Firebase *ref) {
        if(!error){
            [self.delegate dataShouldUpload];
        }
        else  {
            [self connectionProblem:@"There was a problem in completing this request"];
        }
    }];



}
- (void)setPage:(int)pageNr{
    
    self.pdfDataRef = [[Firebase alloc ]initWithUrl:@"https://brilliant-fire-3573.firebaseio.com/"];


    NSDictionary *slideshow = @{

                                @"currentPage": [NSNumber numberWithInt:pageNr],
                                };

    Firebase *slideshowRef = [self.pdfDataRef childByAppendingPath: self.passcode];
    [slideshowRef updateChildValues: slideshow];

}

-(void)pullFromDataBase:(NSString *)passcode {

    self.passcode = passcode;

    NSString *urlString = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@",self.passcode];
    Firebase *ref = [[Firebase alloc] initWithUrl:urlString];

    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {

        if (snapshot.exists)  {

            NSLog(@"%@", snapshot.value[@"name"]);
            NSLog(@"%@",snapshot.value[@"passcode"]);
            self.dataFromDropbox = [[NSData alloc] initWithBase64EncodedString:snapshot.value[@"data"] options:0];
        
            [self.delegate dataDownloaded];
        }
        else if (!snapshot.exists){
            [self.delegate wrongPasscode];
            
        }
        else{
            [self connectionProblem:@"Connection Propblem. Please Retry"];

        }


    } withCancelBlock:^(NSError *error) {
        [self connectionProblem:@"There was a problem in completing this request"];
        NSLog(@"%@", error.description);
    }];

}
-(void)checkPage{

    NSString *urlString = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@",self.passcode];
    Firebase *ref = [[Firebase alloc] initWithUrl:urlString];

    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        [self.delegate updatePage: [snapshot.value[@"currentPage"] intValue]];
        NSLog(@"%@", snapshot.value[@"currentPage"]);
         }];
}
-(void)deleteFile{

    NSString *urlString = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@",self.passcode];
    Firebase *ref = [[Firebase alloc] initWithUrl:urlString];
    [ref removeValueWithCompletionBlock:^(NSError *error, Firebase *ref) {
        if (error) {
            [self connectionProblem:@"Connection Problem. Please Retry"];
        }
    }];
    self.dataFromDropbox = nil;
    self.passcode = nil;
}
-(void)listenAudienceNr{
    NSString *urlString = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@",self.passcode];
    Firebase *ref = [[Firebase alloc] initWithUrl:urlString];

    [ref observeEventType:FEventTypeValue andPreviousSiblingKeyWithBlock:^(FDataSnapshot *snapshot, NSString *prevKey) {
        [self.delegate  updateAudienceNr:[snapshot.value[@"audienceNr"] intValue]];
    }];

}
-(void)checkAudienceNumber{
    NSString *urlString = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@",self.passcode];
    Firebase *ref = [[Firebase alloc] initWithUrl:urlString];

    [ref observeSingleEventOfType:FEventTypeValue andPreviousSiblingKeyWithBlock:^(FDataSnapshot *snapshot, NSString *prevKey) {
        [self updateAudienceNumber:[snapshot.value[@"audienceNr"] intValue]];
    }];

}
-(void)updateAudienceNumber:(int)nr{
    self.pdfDataRef = [[Firebase alloc ]initWithUrl:@"https://brilliant-fire-3573.firebaseio.com/"];


    NSDictionary *slideshow = @{

                                @"audienceNr": [NSNumber numberWithInt:(nr+1)],

                                };

    Firebase *slideshowRef = [self.pdfDataRef childByAppendingPath: self.passcode];
    [slideshowRef updateChildValues: slideshow];


}

-(void)connectionProblem:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
@end
