
//
//  LECColorCollectionView.m
//  Lec
//
//  Created by Juni Lee on 24/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECColorCollectionView.h"
#import "LECColourService.h"

@implementation LECColorCollectionView{
    NSString *selectedColor; // View model?
}

-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        // Initialization code
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.delegate = self;
        self.dataSource = self;
        [self setScrollEnabled:NO];
    }
    return self;
}

+(LECColorCollectionView *)colourCollection
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(([UIScreen mainScreen].bounds.size.height/2)-124, 50, ([UIScreen mainScreen].bounds.size.height/2)-134, 50);
    layout.minimumLineSpacing = 50.0f;
    layout.minimumInteritemSpacing = 30.0f;
//    LECColorCollectionView *cview = [[LECColorCollectionView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] collectionViewLayout:layout];
    LECColorCollectionView *cview = [[LECColorCollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
    return cview;
}


// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return 9;
}
// 2
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.layer.cornerRadius = cell.frame.size.height/2;
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 0;
    
    NSString *cellColor = [[[LECColourService sharedColourService] colourKeys] objectAtIndex:indexPath.row];
    [[LECColourService sharedColourService] addGradientForColour:cellColor toView:[cell contentView]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.colourPickerDelegate colourPickerDismissed:[[[LECColourService sharedColourService] colourKeys] objectAtIndex:indexPath.row]];
    //selectedColor = [[[LECColourService sharedColourService] colourKeys] objectAtIndex:indexPath.row];
    //[[LECColourService sharedColourService] changeGradientToColour:selectedColor forView:colorPickerButton];
    
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
    return CGSizeMake(45, 45);
}


@end
