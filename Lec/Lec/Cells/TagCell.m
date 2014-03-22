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

static void * localContext = &localContext;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.tagNameLabel = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, self.frame.size.width-80, 40)];
        self.tagNameLabel.textColor = [UIColor whiteColor];
        [self.tagNameLabel setDelegate:self];
        self.tagNameLabel.enabled = NO;
        self.tagNameLabel.font = [UIFont fontWithName:DEFAULTFONT size:COURSENAMEECELLFONTSIZE];
        [self addSubview:self.tagNameLabel];
        
        self.tagDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, self.frame.size.width-80, 40)];
        self.tagDescriptionLabel.textColor = [UIColor whiteColor];
        self.tagDescriptionLabel.font = [UIFont fontWithName:DEFAULTFONT size:COURSEDESCRIPTIONCELLFONTSIZE];
        [self addSubview:self.tagDescriptionLabel];
        
        CGRect frame = [self frame];
        frame.size.height = 75;
        [self setFrame:frame];
        [[self contentView] setFrame:frame];
    }
    return self;
}


-(NSString *)editDescription:(NSInteger)tagNum{
    [self.tagNameLabel setEnabled:YES];
    self.currentEditTag = tagNum;
    [self.tagNameLabel becomeFirstResponder];
    return self.tagNameLabel.text;
}

-(void)populateFor:(LECTagCellViewModel *)vm
{
    self.tagNameLabel.text = [vm titleText];
    self.tagDescriptionLabel.text = [vm subText];
    self.tagDescriptionLabel.textColor = [[LECColourService sharedColourService] highlightColourFor:vm.colourString];
    self.tagNameLabel.textColor = [[LECColourService sharedColourService] baseColourFor:vm.colourString];
    self.backgroundColor = [UIColor whiteColor];
    
    [self setupObservingOf:vm];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.renameTagDelegate keyboardEndEditing:textField.text currentTag:self.currentEditTag];
    [self.tagNameLabel setEnabled:NO];
    return YES;
}

#pragma mark - KVO
// seperated off as it's ugly as shit
-(void) setupObservingOf:(LECTagCellViewModel *)vm
{
    [vm addObserver:self forKeyPath:NSStringFromSelector(@selector(name)) options:NSKeyValueObservingOptionNew context:localContext];
}

-(void)deallocObservation:(LECTagCellViewModel *)vm;
{
    @try {
        [vm removeObserver:self forKeyPath:NSStringFromSelector(@selector(name))];
    }
    @catch (NSException * __unused exception) {}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // sanity check to ensure subclassing hasn't screwed us over, best practice
    if (context != localContext) return;
    if ([NSNull null] == change[NSKeyValueChangeNewKey])
    {
        [self deallocObservation:object];
        return;
    }
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(name))])
    {
        self.tagNameLabel.text = change[NSKeyValueChangeNewKey];
    }
}


@end
