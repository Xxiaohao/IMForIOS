//
//  XHMessageViewController.m
//  IMForIOS
//
//  Created by LC on 15/9/17.
//  Copyright (c) 2015年 XH. All rights reserved.
//


#import "XHMessageViewController.h"
#import "XHMessageListController.h"
#import "XHMessageViewTableCell.h"
#import "XHMessageClient.h"

@interface XHMessageViewController ()<MessageViewDelegate>
@property (nonatomic,strong)XHMessageListController *messageListControler;
@end

@implementation XHMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [XHMessageViewTableCell messageViewCellWithTableView:tableView];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.messageListControler = [[XHMessageListController alloc]init];
    
    [self.navigationController pushViewController:self.messageListControler animated:YES];
    
}

#pragma mark - MessageViewDelegate
-(void)showMessageView:(NSDictionary *)dict{
    self.messageListControler.messageFrames = dict[@"offLineMessage"];

}
















@end
