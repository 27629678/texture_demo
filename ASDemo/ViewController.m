//
//  ViewController.m
//  ASDemo
//
//  Created by hzyuxiaohua on 2017/7/17.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

#import "ViewController.h"

#import "NEConferenceInvitationCellNode.h"

#import <Masonry.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface ViewController () <ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) ASTableNode *tableNode;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Demo";
    self.tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    [self.tableNode setDelegate:self];
    [self.tableNode setDataSource:self];
    [self.view addSubview:self.tableNode.view];
    
    [self.tableNode.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - delegate & data source methods

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode
{
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NEConferenceInvitationCellNode *node =
    [[NEConferenceInvitationCellNode alloc] initWithDate:@"2017-7-16 17:00 - 18:00"
                                                location:@"浙江省杭州市滨江区网商路599号网易大厦B-3-10号会议室"
                                                  status:arc4random_uniform(4)];
    
    return node;
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableNode deselectRowAtIndexPath:indexPath animated:YES];
}

@end
