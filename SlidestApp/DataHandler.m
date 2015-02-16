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

    self.slideshow = [PFObject objectWithClassName:@"Slideshow"];
    PFFile *file = [PFFile fileWithData:self.dataFromDropbox contentType:@"pdf"];
    self.slideshow[@"pdf"] = file;
    self.slideshow[@"titleOfSlideshow"] = self.name;
    self.slideshow[@"passcode"] = passcode;
    [self.slideshow saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Saved! %@", error);
    }];
    
}
-(void)deleteFile{

    self.dataFromDropbox = nil;
    self.passcode = nil;
    [self.slideshow deleteInBackground];
}

-(void)parseQuery:(NSString *)passcode {
    self.passcode = passcode;
    PFQuery *query = [PFQuery queryWithClassName:@"Slideshow"];
    [query whereKey:@"passcode" equalTo:passcode];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Found something...
            NSLog(@"Successfully retrieved %lu slideshow.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                PFFile *pdf = [object objectForKey:@"pdf"];
                [pdf getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    self.dataFromDropbox = data;
                    [self.delegate segueToSlideshow];
                }];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

@end
