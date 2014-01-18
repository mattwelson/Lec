//
//  LECViewController.m
//  PullupTable
//
//  Created by Matt Welson on 19/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECViewController.h"

@interface LECViewController ()

@end

@implementation LECViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setData:[NSMutableArray arrayWithObjects:@"Hello",
                   @"Table cell!",
                   @"Awwww yis",
                   @"Mother",
                   @"Flipping",
                   @"Bread crumbs!", nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
}

@end
