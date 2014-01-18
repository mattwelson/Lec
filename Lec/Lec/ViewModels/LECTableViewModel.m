//
//  LECTableViewModel.m
//  Lec
//
//  Created by Codie Westphall on 19/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECTableViewModel.h"

const float LEC_ROW_HEIGHT = 100.0f;

@implementation LECTableViewModel{
    UIScrollView *_scrollView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectNull];
        [self addSubview:_scrollView];
    }
    return self;
}

-(void)layoutSubviews
{
    _scrollView.frame = self.frame;
    [self refreshView];
}

-(void)refreshView {
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, [_dataSource numberOfRows] * LEC_ROW_HEIGHT);
    
    for (int row = 0; row < [_dataSource numberOfRows]; row++) {
        UIView *cell = [_dataSource cellForRow:row];
        float topEdgeForRow = row * LEC_ROW_HEIGHT;
        CGRect frame = CGRectMake(0, topEdgeForRow, _scrollView.frame.size.width, LEC_ROW_HEIGHT);
        cell.frame = frame;
        [_scrollView addSubview:cell];
        
    }
}

#pragma mark - property setters

-(void)setDataSource:(id<LECTableViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self refreshView];
}

@end
