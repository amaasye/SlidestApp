//
//  DataHandler.h
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/13/15.
//  Copyright (c) 2015 Mateusz Pis, Syed Amaanullah and David Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DBChooser/DBChooser.h>
#import <Firebase/Firebase.h>

@protocol DataHandlerDelegate
@optional
- (void)downloadingShouldStart;
- (void)downloadingShouldEnd;
- (void)dataShouldUpload;
- (void)fileIsPDF:(BOOL)isPDF withName:(NSString *)name;
- (void)dataDownloaded;
- (void)updatePage:(int)pageNr;
-(void)updateAudienceNr:(int)nr;
-(void)drawGestureWithpoint:(CGPoint)point andColor:(NSString*)color;

@end
@interface DataHandler : NSObject <UIAlertViewDelegate>
@property NSString *passcode;
@property NSString *name;
@property id<DataHandlerDelegate> delegate;
@property NSData *dataFromDropbox;
@property Firebase *pdfDataRef;
@property int pageNr;
@property int totalPages;
- (void)downloadPDF:(DBChooserResult *)chooser;
- (void)pushDataToDataBase:(NSString *)passcode;
-(void)deleteFile;
-(void)pullFromDataBase:(NSString *)passcode;
- (void)setPage:(int)pageNr;
-(void)checkPage;
-(void)checkAudienceNumber;
-(void)listenAudienceNr;
-(void)updateDrawPosition:(CGPoint)point withColor:(NSString*)color;
-(void)observeDrawPosition;
-(void)setPageAtWatch:(int)number;
-(void)deactivateWatchApp;




@end
