//
//  TagCell.m
//  Lec
//
//  Created by Matt Welson on 26/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "TagCell.h"
#import "LECDefines.h"

@implementation TagCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.tagNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.frame.size.width-80, 40)];
        self.tagNameLabel.textColor = [UIColor whiteColor];
        self.tagNameLabel.font = [UIFont fontWithName:DEFAULTFONT size:COURSENAMEECELLFONTSIZE];
        [self.contentView addSubview:self.tagNameLabel];
        
        self.tagDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, self.frame.size.width-80, 40)];
        self.tagDescriptionLabel.textColor = [UIColor whiteColor];
        self.tagDescriptionLabel.font = [UIFont fontWithName:DEFAULTFONT size:COURSEDESCRIPTIONCELLFONTSIZE];
        [self.contentView addSubview:self.tagDescriptionLabel];
        
        CGRect frame = [self frame];
        frame.size.height = 75;
        [self setFrame:frame];
        [[self contentView] setFrame:frame];
    }
    return self;
}

-(void)populateFor:(LECTagCellViewModel *)vm
{
    self.tagNameLabel.text = [vm titleText];
    self.tagDescriptionLabel.text = [vm subText];
    self.tagDescriptionLabel.textColor = [[LECColourService sharedColourService] highlightColourFor:vm.colourString];
    self.tagNameLabel.textColor = [[LECColourService sharedColourService] baseColourFor:vm.colourString];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
