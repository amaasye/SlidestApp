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

    Firebase *slideshowRef = [self.pdfDataRef childByAppendingPath: @"Slideshows"];
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
    [self.delegate segueToSlideshow];


}

@end
