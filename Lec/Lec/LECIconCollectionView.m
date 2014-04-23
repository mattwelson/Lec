//
//  LECIconCollectionView.m
//  Lec
//
//  Created by Julin Le-Ngoc on 2/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECIconCollectionView.h"
#import "LECIconService.h"

@implementation LECIconCollectionView

-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        // Initialization code
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.delegate = self;
        self.dataSource = self;
        [self setScrollEnabled:YES];
        [self setShowsHorizontalScrollIndicator:YES];
        [self setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
        self.iconArray = [[LECIconService sharedIconService] iconKeys];
    }
    return self;
}

+(LECIconCollectionView *)iconCollection
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(([UIScreen mainScreen].bounds.size.height/2)-134, 50, ([UIScreen mainScreen].bounds.size.height/2)-134, 50);
    layout.minimumLineSpacing = 30.0f;
//    LECIconCollectionView *iview = [[LECIconCollectionView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] collectionViewLayout:layout];
    layout.minimumInteritemSpacing = 35.0f;
    
    LECIconCollectionView *iview = [[LECIconCollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
    return iview;
}

// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return [[LECIconService sharedIconService] iconKeys].count;
}
// 2
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
//    cell.layer.cornerRadius = cell.frame.size.height/2;
//    cell.layer.masksToBounds = YES;
//    cell.layer.borderWidth = 0;
    UIImage *cellIcon = [[LECIconService sharedIconService] iconFor:[self.iconArray objectAtIndex:indexPath.row]];
    cellIcon = [cellIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.backgroundView = [[UIImageView alloc]initWithImage:cellIcon];
    [cell.backgroundView setTintColor:[UIColor whiteColor]];
    
    //cell.backgroundView = cellIcon;
    
    //NSString *cellIcon = [[[LECIconService sharedIconService] iconKeys] objectAtIndex:indexPath.row];
    //[[LECColourService sharedColourService] addGradientForColour:cellColor toView:[cell contentView]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.iconPickerDelegate iconPickerDismissed:[[[LECIconService sharedIconService] iconKeys] objectAtIndex:indexPath.row]];
    
    for(UICollectionView *cell in collectionView.visibleCells){
        [UIView animateWithDuration:0.1 animations:^{
            cell.alpha = 0.0;
        }];
    }
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 50);
}


@end
