//
//  TagCell.h
//  Lec
//
//  Created by Matt Welson on 26/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECTagCellViewModel.h"

@interface TagCell : UITableViewCell

-(void)populateFor:(LECTagCellViewModel *)vm;

@property UILabel *tagNameLabel;
@property UILabel *tagDescriptionLabel;

@end
