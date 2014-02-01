//
//  MainViewController.h
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECHomeViewModel.h"
#import "LECColorCollectionView.h"
#import "LECAddCourseView.h"


//@class LECColorCollectionView;

@interface MainViewController : UIViewController<SaveCourseDelegate, UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegateFlowLayout>


@property UITableView *courseTableView;
@property LECColorCollectionView *colorView;
@property LECHomeViewModel *viewModel;

@end
