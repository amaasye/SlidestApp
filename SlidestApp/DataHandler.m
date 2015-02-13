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
//        self.passcode = self.passcodeTextField.text;
    }];
}

- (void)checkFileType:(NSString *)name {
    if ([name hasSuffix:@"pdf"]) {
        [self.delegate fileIsPDF:YES withName:name];
        self.name = name;
        [self saveFileLocally];
    }
    else {
        [self.delegate fileIsPDF:NO withName:@"File type is not supported"];
    }
}

- (void)saveFileLocally {
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    documentsURL = [documentsURL URLByAppendingPathComponent:@"current.pdf"];

    [self.dataFromDropbox writeToURL:documentsURL atomically:YES];
}

- (void)pushDataToParse:(NSString *)passcode {

    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    documentsURL = [documentsURL URLByAppendingPathComponent:@"current.pdf"];
    NSData *data = [NSData dataWithContentsOfURL:documentsURL];
    self.slideshow = [PFObject objectWithClassName:@"Slideshow"];
    PFFile *file = [PFFile fileWithData:data contentType:@"pdf"];
    self.slideshow[@"pdf"] = file;
    self.slideshow[@"titleOfSlideshow"] = self.name;
    self.slideshow[@"passcode"] = passcode;
    [self.slideshow saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Saved! %@", error);
    }];
    
}
-(void)deleteFileWithName:(NSString*)name{

    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"downloads"];
    path = [path stringByAppendingPathComponent:@"current.pdf"];
    NSError *error;


    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        if (![[NSFileManager defaultManager] removeItemAtPath:path error:&error])
        {
            NSLog(@"Delete file error: %@", error);
        }
    }
    [self.slideshow deleteInBackground];
}


@end
