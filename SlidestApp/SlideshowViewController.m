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

@interface SlideshowViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property CGPDFDocumentRef pdf;
@property int numberOfPages;
@end

@implementation SlideshowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self openPdf];
    
}
-(void)openPdf{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = searchPaths.firstObject;
    NSString *tempPath = [documentsDirectoryPath stringByAppendingPathComponent:@"pdf.pdf"];

    //Display PDF
        CFURLRef pdfURL = CFURLCreateWithFileSystemPath (NULL, (CFStringRef)tempPath, kCFURLPOSIXPathStyle, FALSE);
         self.pdf = CGPDFDocumentCreateWithProvider(CGDataProviderCreateWithURL(pdfURL));
    self.numberOfPages = (int)CGPDFDocumentGetNumberOfPages(self.pdf);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];

    //[self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:5  inSection:0]
        //                        atScrollPosition:UICollectionViewScrollPositionNone
           //                             animated:YES];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        NSLog(@"%d",(int)indexPath.row);
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
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Adjust cell size for orientation


    
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    }
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.collectionView reloadData];
    [self.collectionView performBatchUpdates:nil completion:nil];
}


@end
