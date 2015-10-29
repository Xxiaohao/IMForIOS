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

@interface XHMessageViewController ()<MessageViewDelegate>
{
    XHMessageClient *messageClient;
}
@property (nonatomic,strong)XHMessageListController *messageListController;


@end

@implementation XHMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化消息容器messagesDict
    self.contactsMessages = [NSMutableArray array];
    self.latestMessageDictionary = [NSMutableDictionary dictionary];
    
    //打开与消息服务器的网络连接
    messageClient = [XHMessageClient sharedXHMessageClient];
    [messageClient startConnectSocket];
    messageClient.allData = [[NSMutableData alloc]init];
    messageClient.messageViewDelegate = self;
    
    [self channelActive];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    XHLog(@"contactsMessages.count is %ld",self.contactsMessages.count);
    return self.contactsMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *messageArrays = self.contactsMessages[indexPath.row];
    XHMessageViewTableCell *viewCell = [XHMessageViewTableCell messageViewCellWithTableView:tableView];
    
    NSDictionary *latestMessageDictionary = self.latestMessageDictionary[messageArrays[0][@"senderID"]];
    XHContactModel *contact = [[XHContactModel alloc]init];
    
    //将该cell对应的联系人信息传过去
    for (NSDictionary *contactDict in self.contacts) {
        XHContactModel *contactPerson = [XHContactModel contactWithDict:contactDict];
        if ([latestMessageDictionary[@"senderID"] isEqualToString:contactPerson.userID]) {
            contact = contactPerson;
            break;
        }
    }
    
    [viewCell setValueWithDic:latestMessageDictionary andContact:contact andCount:messageArrays.count];
    
    return viewCell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //得到当前cell
    XHMessageViewTableCell *cell = (XHMessageViewTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.count=0;
    //准备数据 将cell对应的联系人信息、联系人聊天信息传过去
    NSMutableArray *msgsArray = self.contactsMessages[indexPath.row];
    
    XHContactModel *contact = [[XHContactModel alloc]init];
    for (NSDictionary *contactDict in self.contacts) {
        XHContactModel *contactPerson = [XHContactModel contactWithDict:contactDict];
        if ([msgsArray[0][@"senderID"] isEqualToString:contactPerson.userID]) {
            contact = contactPerson;
            break;
        }
    }
    if (self.messageListController ==nil) {
        self.messageListController = [XHMessageListController sharedXHMessageListController];
    }
    [self.messageListController loadAndHandleDataWithContact:contact andMessageArray:msgsArray];
    
    //将该联系人的未读消息（unread）全部标志位已读（read）
    [[XHDataBaseManager sharedXHDataBaseManager] updateMessageWithSender:contact.userID];
    
    //    [msgsArray removeObjectsInRange:NSMakeRange(1, msgsArray.count-1)];
    //    XHLog(@" msgsArray is %@ and msgs == nil  is %d",msgsArray,msgsArray==nil);
    
    [self.navigationController pushViewController:self.messageListController animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - MessageViewDelegate
/**
 *将接收到的消息放在messageview里面的dict中
 *如果程序在后台
 */
-(void)showMessageView:(NSDictionary *)dict{
    //程序不在后台
    NSUInteger count = self.contactsMessages.count;
    if (self.messageListController==nil) {
        self.messageListController = [XHMessageListController sharedXHMessageListController];
    }
    
    NSInteger result = [[XHDataBaseManager sharedXHDataBaseManager] insertMessageWithDict:dict andFlag:@"unread"];
    XHLog(@" result is %ld",result);
    //判断当前显示的是聊天窗口，并且该聊天窗口就是本条消息的聊天窗口
    if (self.messageListController.view.window!=nil && [self.messageListController.senderID isEqualToString:dict[@"senderID"]]) {
        XHLog(@"正在聊天中");
        [self.messageListController handleNewMessage:dict];
        return;
    }
    
    if (count==0) {
        NSMutableArray *msgsArray = [NSMutableArray array];
        //        [msgsArray addObject:dict];
        [msgsArray addObject:dict];
        [self.contactsMessages addObject:msgsArray];
    }else{
        for (int i =0; i<count; i++) {
            NSMutableArray *msgsArray = self.contactsMessages[i];
            XHChatBean *chatBean = [XHChatBean chatWithDict:msgsArray[0]];
            if ([chatBean.senderID isEqualToString:dict[@"senderID"]]) {
                [msgsArray addObject:dict];
                break;
            }
            if (i==count-1) {
                NSMutableArray *msgsArray = [NSMutableArray array];
                [msgsArray addObject:dict];
                //                [msgsArray addObject:dict];
                [self.contactsMessages addObject:msgsArray];
            }
        }
    }
    
    self.latestMessageDictionary[dict[@"senderID"]] = dict;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    //程序在后台
}


/**与消息服务器断开连接 相当于从消息服务器上面注销 */
-(void)didEndConnectToMessageServer{
    XHLog(@"-----didEndConnectToMessageServer--");
    NSDictionary *chatBeanDict = [[NSDictionary alloc]initWithObjectsAndKeys:@"184211",@"userID",@"",@"senderID",@"",@"receiverID",@"",@"AUDIO_SAMPLE_RATE",@"",@"AUDIO_SAMPLE_SIZE_IN_BITS",@"",@"AUDIO_CHANNELS",@[],@"msgFlagQueue",@[],@"msgQueue",@"",@"msg",@"",@"indexs",@"",@"time", nil];
    [messageClient sendingDataWithCommandID:@"130" andCommandResult:@"-1" andCommandContent:chatBeanDict];
}

/**第一次连接上消息服务器 相当于在消息服务器上面注册 */
-(void)channelActive{
    XHChatBean *chatBean = [[XHChatBean alloc]init];
    chatBean.userID=@"184211";
    NSMutableDictionary *chatBeanDict = [chatBean keyValues];
    [messageClient sendingDataWithCommandID:@"110" andCommandResult:@"-1" andCommandContent:chatBeanDict];
}
















@end
