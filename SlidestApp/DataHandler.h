//
//  DataHandler.h
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/13/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DBChooser/DBChooser.h>
#import <Firebase/Firebase.h>

@protocol DataHandlerDelegate
@optional
- (void)downloadingShouldStart;
- (void)downloadingShouldEnd;
- (void)fileIsPDF:(BOOL)isPDF withName:(NSString *)name;
- (void)segueToSlideshow;


@end
@interface DataHandler : NSObject
@property NSString *passcode;
@property NSString *name;
@property id<DataHandlerDelegate> delegate;
@property NSData *dataFromDropbox;
@property Firebase *pdfDataRef;
- (void)downloadPDF:(DBChooserResult *)chooser;
- (void)pushDataToDataBase:(NSString *)passcode;
-(void)deleteFile;
-(void)pullFromDataBase:(NSString *)passcode;

@end
