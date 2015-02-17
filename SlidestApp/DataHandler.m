//
//  DataHandler.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/13/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "DataHandler.h"


@implementation DataHandler

- (void)downloadPDF:(DBChooserResult *)chooser {
    [self.delegate downloadingShouldStart];
    NSURLRequest *request = [NSURLRequest requestWithURL:chooser.link];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.dataFromDropbox = data;

        [self.delegate downloadingShouldEnd];
        [self checkFileType:chooser.name];
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



- (void)pushDataToDataBase:(NSString *)passcode {

    self.passcode = passcode;
    self.pdfDataRef = [[Firebase alloc ]initWithUrl:@"https://brilliant-fire-3573.firebaseio.com/"];
    NSString *pdfData = [self.dataFromDropbox base64EncodedStringWithOptions:0];
    //NSData *data = [[NSData alloc] initWithBase64EncodedString:stringForm options:0];


    NSDictionary *slideshow = @{
                                @"name": self.name,
                                @"data": pdfData,
                                @"passcode": self.passcode,
                                @"currentPage": [NSNumber numberWithInt:0],
                                };

    Firebase *slideshowRef = [self.pdfDataRef childByAppendingPath: self.passcode];
    NSDictionary *slideshows = @{
                            @"slideshow": slideshow,
                            };
    [slideshowRef setValue: slideshows];



}
-(void)deleteFile{

    self.dataFromDropbox = nil;
    self.passcode = nil;
}

-(void)pullFromDataBase:(NSString *)passcode {
    self.passcode = passcode;
    NSString *urlString = [NSString stringWithFormat:@"https://brilliant-fire-3573.firebaseio.com/%@/slideshow",self.passcode];
    Firebase *ref = [[Firebase alloc] initWithUrl:urlString];

    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@", snapshot.value[@"name"]);
        NSLog(@"%@",snapshot.value[@"passcode"]);
        self.dataFromDropbox = [[NSData alloc] initWithBase64EncodedString:snapshot.value[@"data"] options:0];
        
        [self.delegate segueToSlideshow];

    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];


}

@end
