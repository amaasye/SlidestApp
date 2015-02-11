//
//  SlideshowViewController.m
//  SlidestApp
//
//  Created by Syed Amaanullah on 2/9/15.
//  Copyright (c) 2015 Mateusz Pis & Syed Amaanullah. All rights reserved.
//

#import "SlideshowViewController.h"
#import "PageCell.h"
@interface SlideshowViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SlideshowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 15;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PageCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PageCell" forIndexPath:indexPath];
   // CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height );
    //SlidePage *pdfView = [[SlidePage alloc] initWithFrame:frame];
   // pdfView.pageNr = indexPath.row +1;
   // [cell addSubview:pdfView];
    [cell openFile];
    cell.pageNr = (int) indexPath.row+1;
    NSLog(@"%d",cell.pageNr);

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Adjust cell size for orientation
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
        return CGSizeMake(width, height);
}

@end
