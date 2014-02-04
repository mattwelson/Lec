//
//  LECColorCollectionView.h
//  Lec
//
//  Created by Juni Lee on 24/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColourPickerDelegate <NSObject>

-(void) colourPickerDismissed:(NSString *)colourString;

@end

@interface LECColorCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>

+(LECColorCollectionView *)colourCollection;
@property (nonatomic, assign) id<ColourPickerDelegate> colourPickerDelegate;

@end


