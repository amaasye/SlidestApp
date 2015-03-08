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

@interface SlideshowViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, DataHandlerDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *draw;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIImageView *drawImageView;

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property CGPDFDocumentRef pdf;
@property int numberOfPages;
@property int currentPageNr;
@end

@implementation SlideshowViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentPageNr = 0;
    [self setUIElements];
    [self openPdf];


}

-(void)setUIElements {

    self.navigationController.navigationBar.hidden = YES;
    self.backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.topLabel.hidden = YES;
    self.topLabel.backgroundColor = [UIColor colorWithRed:34/255.0f green:167/255.0f blue:240/255.0f alpha:1.0f];
    self.backButton.hidden = YES;
    self.draw.hidden = YES;
    self.closeButton.hidden = YES;
    self.panGestureRecognizer.enabled = NO;
    self.collectionView.userInteractionEnabled = YES;
}

-(void)openPdf{

    CFDataRef myPDFData = (__bridge CFDataRef)self.dataHandler.dataFromDropbox;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
    self.pdf = CGPDFDocumentCreateWithProvider(provider);
   
    self.numberOfPages = (int)CGPDFDocumentGetNumberOfPages(self.pdf);
    CFRelease(provider);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.dataHandler.delegate = self;

    if (!self.presenter) {
        [self.dataHandler checkAudienceNumber];
        [self.dataHandler checkPage];
        [self.dataHandler observeDrawPosition];

    }

   }

- (IBAction)tapped:(UITapGestureRecognizer *)sender {
    if (self.topLabel.hidden) {
        self.topLabel.hidden = NO;
        self.backButton.hidden = NO;
        self.draw.hidden = NO;

    }

    else {
        self.topLabel.hidden = YES;
        self.backButton.hidden = YES;
        self.draw.hidden = YES;

    }

}
-(void)updateAudienceNr:(int)nr{
    NSLog(@"Audience memeber connected. Total :%i",nr);
}
-(BOOL)shouldAutorotate{
    return YES;
}

- (IBAction)drawTapped:(UIButton *)sender {
    self.topLabel.hidden = YES;
    self.backButton.hidden = YES;
    self.draw.hidden = YES;
    self.draw.hidden = YES;
    self.collectionView.userInteractionEnabled = NO;
    self.tapGestureRecognizer.enabled = NO;
    self.panGestureRecognizer.enabled = YES;
    self.closeButton.hidden = NO;

    //setup drawing coordinates;
    fromPointX = 0;
    fromPointY = 0;
    toPointX = 0;
    toPointX = 0;
}
- (IBAction)closeTapped:(id)sender {

    self.topLabel.hidden = NO;
    self.backButton.hidden = NO;
    self.draw.hidden = NO;
    self.draw.hidden = NO;
    self.collectionView.userInteractionEnabled = YES;
    self.tapGestureRecognizer.enabled = YES;
    self.panGestureRecognizer.enabled = NO;

    self.closeButton.hidden = YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
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

        [self.dataHandler updateDrawPosition:CGPointMake(xPercentage, yPercentage)];

        [self.collectionView.visibleCells.firstObject addDrawFromPoint:CGPointMake(fromPointX, fromPointY) toPoint:CGPointMake(toPointX, toPointY)];

        fromPointX = toPointX;
        fromPointY = toPointY;
        
    }

}
-(void)drawGestureWithpoint:(CGPoint)point{

    toPointX = (self.view.frame.size.width /100) * point.x;
    toPointY = (self.view.frame.size.height/100) * point.y;


    if (((fromPointX-toPointX >40) || (fromPointX-toPointX < -40) || (fromPointY-toPointY >40) || (fromPointY-toPointY <-40) )) {
        fromPointX = toPointX;
        fromPointY = toPointY;
    }

    else  {

        [self.collectionView.visibleCells.firstObject addDrawFromPoint:CGPointMake(fromPointX, fromPointY) toPoint:CGPointMake(toPointX, toPointY)];

        fromPointX = toPointX;
        fromPointY = toPointY;
        
    }

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

@end
