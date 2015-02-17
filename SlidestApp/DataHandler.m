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



- (void)pushDataToParse:(NSString *)passcode {

    self.passcode = passcode;


}
-(void)deleteFile{

    self.dataFromDropbox = nil;
    self.passcode = nil;
}

-(void)parseQuery:(NSString *)passcode {
    self.passcode = passcode;
    [self.delegate segueToSlideshow];


}

@end
