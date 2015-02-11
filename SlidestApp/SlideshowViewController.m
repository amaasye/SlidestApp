//
//  SlideshowViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/9/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "SlideshowViewController.h"
#import "PageCell.h"
#import "PageScrollView.h"

@interface SlideshowViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SlideshowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 15;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PageCell" forIndexPath:indexPath];
//    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height );
//    PageScrollView *pdfView = [[PageScrollView alloc] initWithFrame:frame];
//    [pdfView openFile];
//    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    pdfView.pageNr = (int)indexPath.row +1;
//    [cell addSubview:pdfView];

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
    [self.collectionView performBatchUpdates:nil completion:nil];
}


@end
