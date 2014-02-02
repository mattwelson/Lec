//
//  LECIconCollectionView.h
//  Lec
//
//  Created by Julin Le-Ngoc on 2/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IconPickerDelegate <NSObject>

-(void) iconPickerDismissed:(NSString *)iconString;

@end

@interface LECIconCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>

+(LECIconCollectionView *)iconCollection;

@property NSArray *iconArray;
@property (nonatomic, assign) id<IconPickerDelegate> iconPickerDelegate;


@end
