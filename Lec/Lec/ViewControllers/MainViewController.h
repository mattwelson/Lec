//
//  MainViewController.h
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#import "LECHomeViewModel.h"

#import "LECAddCourseView.h"

//#import "LECColorCollectionView.h"
//#import "LECIconCollectionView.h"


@interface MainViewController : UIViewController<AddCourseDelegate,UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegateFlowLayout, ADBannerViewDelegate>


@property UITableView *courseTableView;
//@property LECColorCollectionView *colorView;
@property LECHomeViewModel *viewModel;
@property (nonatomic, strong) UIDynamicAnimator *animator;


@end
