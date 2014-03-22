//
//  TagCell.h
//  Lec
//
//  Created by Matt Welson on 26/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECTagCellViewModel.h"

@protocol RenameTagDelegate <NSObject>

-(void) keyboardEndEditing:(NSString *)newTagDescription currentTag:(NSInteger)currentTag;

@end

@interface TagCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, assign) id<RenameTagDelegate> renameTagDelegate;

-(void)populateFor:(LECTagCellViewModel *)vm;
-(NSString *)editDescription:(NSInteger)tagNum;

@property UITextField *tagNameLabel;
@property UILabel *tagDescriptionLabel;
@property NSInteger currentEditTag;

@end
