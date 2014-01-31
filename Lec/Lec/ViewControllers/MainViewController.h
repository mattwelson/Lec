//
//  MainViewController.h
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECImportHeader.h"

@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property UITableView *courseTableView;
@property UICollectionView *colorView;
@property LECHomeViewModel *viewModel;

@end
