//
//  SlideshowViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/9/15.
//  Copyright (c) 2015 Mateusz Pis, Syed Amaanullah and David Miller. All rights reserved.
//

#import "SlideshowViewController.h"
#import "PageScrollView.h"
#import "CustomCell.h"

@interface SlideshowViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, DataHandlerDelegate, UIDocumentInteractionControllerDelegate>

//this view cointains button appears/desappears on tap, but button on remote settings
@property (strong, nonatomic) IBOutlet UIView *saveButtonBackgroundView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIView *bottomNavigationView;
@property (retain)UIDocumentInteractionController *documentController;


//draw Controls

@property (strong, nonatomic) IBOutlet UIButton *blackButton;

@property (strong, nonatomic) IBOutlet UIButton *blueButton;

@property (strong, nonatomic) IBOutlet UIButton *redButton;

@property (strong, nonatomic) IBOutlet UIButton *draw;

//gesture recognizers
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;

//pdf rendering objects
@property CGPDFDocumentRef pdf;
@property int numberOfPages;
@property int currentPageNr;
@end

@implementation SlideshowViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataHandler.pageNr = 0;
    [self setUIElements];

    [self openPdf];


}

-(void)setUIElements {

    self.navigationController.navigationBar.hidden = YES;
    self.backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.topLabel.hidden = YES;

    self.backButton.hidden = YES;
    self.draw.hidden = YES;
    self.blackButton.hidden = YES;
    self.blueButton.hidden = YES;
    self.redButton.hidden = YES;
    self.panGestureRecognizer.enabled = NO;
    self.collectionView.userInteractionEnabled = YES;
    currenDrawColor = @"black";

    self.blackButton.layer.cornerRadius = 30;
    self.blackButton.layer.borderWidth = 1;
    self.blackButton.layer.borderColor = [[UIColor blackColor]CGColor];

    self.redButton.layer.cornerRadius = 30;
    self.redButton.layer.borderWidth = 1;
    self.redButton.layer.borderColor = [[UIColor blackColor]CGColor];

    self.blueButton.layer.cornerRadius = 30;
    self.blueButton.layer.borderWidth = 1;
    self.blueButton.layer.borderColor = [[UIColor blackColor]CGColor];

    self.saveButtonBackgroundView.hidden = YES;
    self.saveButton.layer.cornerRadius = 15;
    self.draw.hidden = YES;
    self.bottomNavigationView.hidden = YES;

}

-(void)openPdf{

    CFDataRef myPDFData = (__bridge CFDataRef)self.dataHandler.dataFromDropbox;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
    self.pdf = CGPDFDocumentCreateWithProvider(provider);

    self.numberOfPages = (int)CGPDFDocumentGetNumberOfPages(self.pdf);
    self.dataHandler.totalPages = (int)CGPDFDocumentGetNumberOfPages(self.pdf);
    CFRelease(provider);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.dataHandler.delegate = self;

    if (!self.presenter) {
        [self.dataHandler checkAudienceNumber];
        [self.dataHandler checkPage];
        [self.dataHandler observeDrawPosition];
        [self.dataHandler listenUserSettings];
        [self.draw removeFromSuperview];
        [self.bottomNavigationView removeFromSuperview];
    }
    else{
        // Watch listener enabled only for presenter
        [self setWatchListener];
        [self.dataHandler setPageAtWatch:0];
        [self.saveButtonBackgroundView removeFromSuperview];

    }

}

- (IBAction)tapped:(UITapGestureRecognizer *)sender {
    if (self.topLabel.hidden) {
        self.topLabel.hidden = NO;
        self.backButton.hidden = NO;
        self.draw.hidden = NO;
        self.saveButtonBackgroundView.hidden = NO;
        self.bottomNavigationView.hidden = NO;
    }

    else {
        self.topLabel.hidden = YES;
        self.backButton.hidden = YES;
        self.draw.hidden = YES;
        self.saveButtonBackgroundView.hidden = YES;
        self.bottomNavigationView.hidden = YES;

    }

}
-(BOOL)shouldAutorotate{
    return YES;
}

-(void)updateAudienceNr:(int)nr{
    NSLog(@"Audience memeber connected. Total :%i",nr);
}

- (IBAction)drawTapped:(UIButton *)sender {

    if ([sender.titleLabel.text isEqual: @"DRAW"]) {

        self.topLabel.hidden = YES;
        self.backButton.hidden = YES;
        self.redButton.hidden = NO;
        self.blackButton.hidden = NO;
        self.blueButton.hidden = NO;
        self.collectionView.userInteractionEnabled = NO;
        self.tapGestureRecognizer.enabled = NO;
        self.panGestureRecognizer.enabled = YES;


        //setup drawing coordinates;
        fromPointX = 0;
        toPointX = 0;

        [self.draw setTitle:@"CLOSE" forState:UIControlStateNormal];
    }
    else {

        self.topLabel.hidden = NO;
        self.backButton.hidden = NO;
        self.redButton.hidden = YES;
        self.blackButton.hidden = YES;
        self.blueButton.hidden = YES;
        self.collectionView.userInteractionEnabled = YES;
        self.tapGestureRecognizer.enabled = YES;
        self.panGestureRecognizer.enabled = NO;

        [self.draw setTitle:@"DRAW" forState:UIControlStateNormal];
    }
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
- (IBAction)savePDF:(id)sender {
    NSURL *fileURL = [NSURL fileURLWithPath:[self.dataHandler savePDFAndReturnPath]];

    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    self.documentController.delegate = self;

    [self.documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];

}

- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)sender {

    [self analizeDrawGestureWithpoint:[sender locationInView:self.view]];


}
-(void)analizeDrawGestureWithpoint:(CGPoint)point{

    toPointX = point.x;
    toPointY = point.y;


    if (((fromPointX-toPointX >40) || (fromPointX-toPointX < -40) || (fromPointY-toPointY >40) || (fromPointY-toPointY <-40) )) {
        fromPointX = toPointX;
        fromPointY = toPointY;
    }

    else if ((fromPointX-toPointX >10) || (fromPointX-toPointX < -10) || (fromPointY-toPointY >10) || (fromPointY-toPointY <-10) ) {


        int xPercentage = toPointX / (self.view.frame.size.width/100);
        int yPercentage = toPointY / (self.view.frame.size.height/100);

        [self.dataHandler updateDrawPosition:CGPointMake(xPercentage, yPercentage) withColor:currenDrawColor];

        [self.collectionView.visibleCells.firstObject addDrawFromPoint:CGPointMake(fromPointX, fromPointY) toPoint:CGPointMake(toPointX, toPointY) withColor:currenDrawColor];

        fromPointX = toPointX;
        fromPointY = toPointY;

    }

}
-(void)drawGestureWithpoint:(CGPoint)point andColor:(NSString*)color{

    toPointX = (self.view.frame.size.width /100) * point.x;
    toPointY = (self.view.frame.size.height/100) * point.y;

    if (((fromPointX-toPointX >40) || (fromPointX-toPointX < -40) || (fromPointY-toPointY >40) || (fromPointY-toPointY <-40) )) {
        fromPointX = toPointX;
        fromPointY = toPointY;
    }

    else  {

        [self.collectionView.visibleCells.firstObject addDrawFromPoint:CGPointMake(fromPointX, fromPointY) toPoint:CGPointMake(toPointX, toPointY) withColor:color];

        fromPointX = toPointX;
        fromPointY = toPointY;

    }

}

-(void)userSettingsShouldChange:(BOOL)canSwipe andCanSave:(BOOL)canSave{

    self.collectionView.userInteractionEnabled = canSwipe;
    self.saveButton.hidden = !canSave;
    
}

- (IBAction)blackButtonTapped:(id)sender {
    currenDrawColor = @"black";
}

- (IBAction)blueButtonTapped:(id)sender {
    currenDrawColor = @"blue";

}
- (IBAction)redButtonTapped:(id)sender {
    currenDrawColor = @"red";

}


#pragma mark collecionView

- (void)updatePage:(int)pageNr{

    self.currentPageNr = pageNr;
    self.topLabel.text = [NSString stringWithFormat:@"%d",pageNr +1];

    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPageNr  inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:YES];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        if (self.presenter) {
            [self.dataHandler setPage:(int)indexPath.row];
        }
        self.currentPageNr = (int)indexPath.row;


    }
    self.topLabel.text = [NSString stringWithFormat:@"%d", self.currentPageNr+1];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.numberOfPages;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    CustomCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PageCell" forIndexPath:indexPath];
    CGRect frame =  CGRectMake(0, 0, collectionView.frame.size.width, collectionView.frame.size.height);
    PageScrollView *page = [[PageScrollView alloc] initWithFrame:frame];
    [page displayPdf:self.pdf];
    page.backgroundColor = [UIColor whiteColor];
    page.pageNr = (int) indexPath.row;
    cell.pageView = page;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Adjust cell size for orientation

    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    }
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.collectionView reloadData];
    [self.collectionView performBatchUpdates:nil completion:nil];
}

-(void)setWatchListener{


    [NSTimer scheduledTimerWithTimeInterval:0.2f
                                     target:self selector:@selector(listenForChangesFromWatch) userInfo:nil repeats:YES];
}

-(void)listenForChangesFromWatch{

    NSUserDefaults *defaults = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.Matt"];

    int pageNr = (int)[defaults integerForKey:@"pageNr"];

    if (pageNr != self.currentPageNr ) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:pageNr  inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft
                                            animated:YES];
        self.currentPageNr = pageNr;
        [self.dataHandler setPage:pageNr];
        self.topLabel.text = [NSString stringWithFormat:@"%d",pageNr+1];
        
    }
}
@end
