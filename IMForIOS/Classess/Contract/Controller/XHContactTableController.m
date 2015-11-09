//
//  XHContactTableController.m
//  IMForIOS
//
//  Created by LC on 15/9/18.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHContactTableController.h"
#import "XHContactTableViewCell.h"
#import "XHContactModel.h"
#import "XHAsyncSocketClient.h"
#import "XHUserInfo.h"
#import "YXLDetail.h"

@interface XHContactTableController ()


@end

@implementation XHContactTableController

-(void)setContacts:(NSArray *)contacts{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in contacts) {
        if (![dict[@"userID"] isEqualToString:[XHUserInfo sharedXHUserInfo].userID]) {
            XHContactModel *model = [XHContactModel contactWithDict:dict];
//            XHLog(@"---contactTable--%@",model.userID);
            [array addObject:model];
        }
    }
    _contacts=array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.contentOffset=CGPointMake(0, 64);
    NSLog(@"contactTable is init");
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"count is---- %ld",self.contacts.count);
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XHContactModel *contact = self.contacts[indexPath.row];
    static NSString *ID=@"contact_cell";
    XHContactTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!contactCell) {
        contactCell = [[[NSBundle mainBundle]loadNibNamed:@"XHContactTableViewCell" owner:nil options:nil]firstObject];
    }
    contactCell.contactModel=contact;
    return contactCell;
}

#pragma mark tableView delegate
/**
 *  tableViewcell点击
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XHContactModel *contact = self.contacts[indexPath.row];
    NSString *name = contact.userName;
    YXLDetail *detail = [YXLDetail sharedYXLDetail];
    [detail setButtonWithNSString:@"发送消息"];
    detail.title= [NSString stringWithFormat:@"%@的详情",name];
    detail.contactModel = contact;
    [self.navigationController pushViewController:detail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    XHLog(@"------");
}


@end
