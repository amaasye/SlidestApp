//
//  SlideshowViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/9/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "SlideshowViewController.h"
#import "PageScrollView.h"
#import "CustomCell.h"
#import "ParseSession.h"

@interface SlideshowViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, ParseSessionDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property CGPDFDocumentRef pdf;
@property int numberOfPages;
@property int currentPageNr;
@property ParseSession *session;
@end

@implementation SlideshowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.session = [ParseSession new];
    self.session.delegate = self;
    if (self.presenter) {
        [self.session startConnectivity:self.dataHandler.passcode];
    }
    self.currentPageNr = 0;
    [self openPdf];

}
-(void)openPdf{

    CFDataRef myPDFData = (__bridge CFDataRef)self.dataHandler.dataFromDropbox;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
    self.pdf = CGPDFDocumentCreateWithProvider(provider);
   
    self.numberOfPages = (int)CGPDFDocumentGetNumberOfPages(self.pdf);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if (self.presenter ==NO) {
        [NSTimer scheduledTimerWithTimeInterval:.5f
                                         target:self selector:@selector(askForPageNr) userInfo:nil repeats:YES];
    }
}
-(void)askForPageNr{
    [self.session getPageWithPasscode:self.dataHandler.passcode];
}
-(void)updateCollecionViewPage:(int)pageNr{
   // if (self.currentPageNr != pageNr) {
        self.currentPageNr = pageNr;


    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPageNr  inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:YES];
   // }

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        if (self.presenter) {
            [self.session updatePageWithNr:(int)indexPath.row];
        }
        self.currentPageNr = (int)indexPath.row;


    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.numberOfPages;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PageCell" forIndexPath:indexPath];
    CGRect frame =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    PageScrollView *page = [[PageScrollView alloc] initWithFrame:frame];
    [page displayPdf:self.pdf];
    page.backgroundColor = [UIColor whiteColor];
    page.pageNr = (int) indexPath.row;
    cell.pageView = page;


    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPathß
{
    // Adjust cell size for orientation


    
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    }
    return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.collectionView reloadData];
    [self.collectionView performBatchUpdates:nil completion:nil];
}

@end
