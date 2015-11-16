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
#import "XHChatBean.h"
#import "XHDataBaseManager.h"
#import "XHUserInfo.h"
#import "YXLDetail.h"
#import "TYImageCache.h"

@interface XHMessageViewController ()<MessageViewDelegate,YXLDetailDelegate>
{
    XHMessageClient *messageClient;
}
@property (nonatomic,strong)XHMessageListController *messageListController;


@end

@implementation XHMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化消息容器
    self.contactsMessages = [NSMutableArray array];
    self.latestMessageArray = [NSMutableArray array];
    
    //如果沙盒中的msgViewArray为空，则初始化
    if ([XHUserInfo sharedXHUserInfo].msgViewArray==nil) {
        [XHUserInfo sharedXHUserInfo].msgViewArray = [NSMutableArray array];
    }
    self.latestMessageArray = [XHUserInfo sharedXHUserInfo].msgViewArray;
    
    messageClient = [XHMessageClient sharedXHMessageClient];
    messageClient.messageViewDelegate = self;
    [YXLDetail sharedYXLDetail].detailDelegate = self;
    [self channelActive];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.latestMessageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XHMessageViewTableCell *viewCell = [XHMessageViewTableCell messageViewCellWithTableView:tableView];

   NSDictionary *latestMessageDictionary =self.latestMessageArray[indexPath.row];
    XHContactModel *contact = [[XHContactModel alloc]init];
    
    //将该cell对应的联系人信息传过去
    for (NSDictionary *contactDict in self.contacts) {
        XHContactModel *contactPerson = [XHContactModel contactWithDict:contactDict];
        if ([latestMessageDictionary[@"senderID"] isEqualToString:contactPerson.userID]) {
            contact = contactPerson;
            break;
        }
    }
    
    NSArray *msgsArray = [self getMsgsFromContactsMessagesWithSenderID:latestMessageDictionary[@"senderID"]];
    
    [viewCell setValueWithDic:latestMessageDictionary andContact:contact andCount:msgsArray.count];
    return viewCell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //得到当前cell
    XHMessageViewTableCell *cell = (XHMessageViewTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.count=0;

    //准备数据 将cell对应的联系人信息、联系人聊天信息传过去
    NSDictionary *latestMessageDictionary = self.latestMessageArray[indexPath.row];
//    NSArray *msgsArray = [self getMsgsFromContactsMessagesWithSenderID:latestMessageDictionary[@"senderID"]];
//    if (msgsArray==nil) {
//        msgsArray =[[XHDataBaseManager sharedXHDataBaseManager] readMessageWithSender:latestMessageDictionary[@"senderID"] andCurrentPage:1];
////        [self.contactsMessages addObject:msgsArray];
//    }else{
//        [self.contactsMessages removeObject:msgsArray];
//    }
    
    XHContactModel *contact = [[XHContactModel alloc]init];
    for (NSDictionary *contactDict in self.contacts) {
        XHContactModel *contactPerson = [XHContactModel contactWithDict:contactDict];
        if ([latestMessageDictionary[@"senderID"] isEqualToString:contactPerson.userID]) {
            contact = contactPerson;
            break;
        }
    }
    
    [self pushToMessageListViewControllerWithContact:contact];
//    if (self.messageListController ==nil) {
//        self.messageListController = [XHMessageListController sharedXHMessageListController];
//    }
//    //将需要的数据传到messageListController
//    [self.messageListController loadAndHandleDataWithContact:contact andMessageArray:msgsArray];
//    
//    //将该联系人的未读消息（unread）全部标志位已读（read）
//    [[XHDataBaseManager sharedXHDataBaseManager] updateMessageWithSender:contact.userID];
//    
////    [self.contactsMessages removeObject:msgsArray];
//    [self.latestMessageArray removeObject:latestMessageDictionary];
//    [self.latestMessageArray insertObject:latestMessageDictionary atIndex:0];
//
    [self.navigationController pushViewController:self.messageListController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - MessageView  Delegate
/** 将接收到的消息放在messageview里面的contactsMessages中 */
-(void)showMessageView:(NSMutableDictionary *)dict{
    //程序不在后台

    NSUInteger count = self.contactsMessages.count;
    if (self.messageListController==nil) {
        self.messageListController = [XHMessageListController sharedXHMessageListController];
    }
    
    NSString *msg = @"";
    NSString *indexs = @"";
    //图片写本地
    XHChatBean *chatBean = [XHChatBean objectWithKeyValues:dict];
    for (int i=0; i<chatBean.msgFlagQueue.count; i++) {
        if ([chatBean.msgFlagQueue[i] intValue]==0) {
            NSString *text = chatBean.msgQueue[i];
            msg = [msg stringByAppendingString:text];
            indexs = [indexs stringByAppendingString:[NSString stringWithFormat: @"0%ld,",text.length]];
        }else if ([chatBean.msgFlagQueue[i] intValue]==1) {
            CGFloat time = [[NSDate date]timeIntervalSince1970];
            NSString *timeString = [[NSString stringWithFormat:@"%f",time] stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString *name = [timeString stringByAppendingString:[NSString stringWithFormat:@"%d.png",arc4random_uniform(1000)]];
            UIImage *img = [UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:dict[@"msgQueue"][i] options:0]];
            BOOL b = [[TYImageCache cache] saveImageFromName:name image:img];
            XHLog(@"---b--is %d---",b);
            msg = [msg stringByAppendingString:name];
            indexs = [indexs stringByAppendingString:[NSString stringWithFormat: @"1%ld,",name.length]];
        }
    }
        XHLog(@" dict is %@",dict);
    
    //消息写库
    chatBean.msg = msg;
    chatBean.indexs = indexs;
    NSDictionary * dictionary = chatBean.keyValues;
    [[XHDataBaseManager sharedXHDataBaseManager] insertMessageWithDict:dictionary andFlag:@"unread"];
    
    //使用最新的dict更新latestMessageArray
    [self latestMessageArrayAddObjectWithDict:dictionary];
    
    //判断当前显示的是聊天窗口，并且该聊天窗口就是本条消息的聊天窗口
    if (self.messageListController.view.window!=nil && [self.messageListController.senderID isEqualToString:dictionary[@"senderID"]]) {
        XHLog(@"正在聊天中");
        [self.messageListController handleNewMessage:dictionary AndFlag:@""];
        return;
    }
    
    if (count==0) {
        NSMutableArray *msgsArray = [NSMutableArray array];
        [msgsArray addObject:dictionary];
        [self.contactsMessages addObject:msgsArray];
    }else{
        for (int i =0; i<count; i++) {
            NSMutableArray *msgsArray = self.contactsMessages[i];
            XHChatBean *chatBean = [XHChatBean chatWithDict:msgsArray[0]];
            if ([chatBean.senderID isEqualToString:dictionary[@"senderID"]]) {
                [msgsArray addObject:dictionary];
                break;
            }
            if (i==count-1) {
                NSMutableArray *msgsArray = [NSMutableArray array];
                [msgsArray addObject:dictionary];

                [self.contactsMessages addObject:msgsArray];
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setUnreadMessagesCount];
        [self.tableView reloadData];
    });
    //程序在后台
}

#pragma mark - YXLDetailDelegate
-(void)pushToMessageListViewControllerWithContact:(XHContactModel *)contact{
//    [[UIApplication sharedApplication] keyWindow].rootViewController = self.navigationController;
    [self pushToMessageListWithContact:contact];
}

#pragma mark 抽出会重复使用的方法
/**从contactsMessages中获取需要的最新消息 */
-(NSArray *)getMsgsFromContactsMessagesWithSenderID:(NSString *)senderID{
    for (NSArray *msgs in self.contactsMessages) {
        if ([msgs[0][@"senderID"] isEqualToString:senderID]) {
            return msgs;
        }
    }
    return nil;
}

/**将最新的消息放入latestMessageArray中  */
-(void)latestMessageArrayAddObjectWithDict:(NSDictionary *)dict{
    BOOL flag=NO;//用来判断该条消息的发送者是否已经在消息列表中显示着
    for (NSDictionary *oldDict in self.latestMessageArray) {
        if ([oldDict[@"senderID"] isEqualToString:dict[@"senderID"]]) {
            [self.latestMessageArray removeObject:oldDict];
            [self.latestMessageArray insertObject:dict atIndex:0];
            flag=YES;
            break;
        }
    }
    if (!flag) {
        [self.latestMessageArray insertObject:dict atIndex:0];
    }
    [[XHUserInfo sharedXHUserInfo]saveMsgViewArrayInToSanbox];
}

/**
 *  在tabBarItem上面显示所有未读消息的条数 badgeValue
 */
-(void)setUnreadMessagesCount{
    NSInteger count = 0 ;
    for (NSMutableArray *array in self.contactsMessages) {
        count+=array.count;
        XHLog(@"未读消息的条数 is %ld",array.count);
    }
    if (count==0) {
        self.tabBarItem.badgeValue = nil;
    }else if(count>99){
        self.tabBarItem.badgeValue = @"";
    }else{
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",count];
    }
}

/**
 *  跳转到messageListViewController的方法 查看详细消息
 */
-(void)pushToMessageListWithContact:(XHContactModel *)contact{
//    XHLog(@" contact.userid is %@",contact.userID);
    for (NSDictionary *latestMessageDictionary in self.latestMessageArray) {
        if ([latestMessageDictionary[@"senderID"] isEqualToString:contact.userID]) {
            [self.latestMessageArray removeObject:latestMessageDictionary];
            [self.latestMessageArray insertObject:latestMessageDictionary atIndex:0];
            break;
        }
    }
    
    NSArray *msgsArray = [self getMsgsFromContactsMessagesWithSenderID:contact.userID];
    if (msgsArray==nil) {
        msgsArray =[[XHDataBaseManager sharedXHDataBaseManager] readMessageWithSender:contact.userID andCurrentPage:1];
    }else{
        [self.contactsMessages removeObject:msgsArray];
    }
    
    if (self.messageListController ==nil) {
        self.messageListController = [XHMessageListController sharedXHMessageListController];
    }
    //将需要的数据传到messageListController
    [self.messageListController loadAndHandleDataWithContact:contact andMessageArray:msgsArray];
    //将该联系人的未读消息（unread）全部标志位已读（read）
    [[XHDataBaseManager sharedXHDataBaseManager] updateMessageWithSender:contact.userID];
//    [self.navigationController pushViewController:self.messageListController animated:YES];
}

#pragma mark 登录注销
/**与消息服务器断开连接 相当于从消息服务器上面注销 */
-(void)didEndConnectToMessageServer{
    XHLog(@"-----didEndConnectToMessageServer--");
    XHChatBean *chatBean = [[XHChatBean alloc]init];
    chatBean.userID=[XHUserInfo sharedXHUserInfo].userID;
    NSMutableDictionary *chatBeanDict = [chatBean keyValues];
    [messageClient channelINActiveWithCommandContent:[chatBeanDict JSONString]];
}

/**第一次连接上消息服务器 相当于在消息服务器上面注册 */
-(void)channelActive{
    XHLog(@"==============active===========");
    XHChatBean *chatBean = [[XHChatBean alloc]init];
    chatBean.userID=[XHUserInfo sharedXHUserInfo].userID;
    NSMutableDictionary *chatBeanDict = [chatBean keyValues];
    [messageClient channelActiveWithCommandContent:[chatBeanDict JSONString]];
    //    [messageClient sendingDataWithCommandID:@"110" andCommandResult:@"-1" andCommandContent:chatBeanDict];
}

-(void)setContacts:(NSArray *)contacts{
    _contacts = contacts;
    [self.tableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self setUnreadMessagesCount];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc{
    XHLog(@"---挂了挂了挂了挂了----%s-----",__func__);
}

@end
