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

@interface XHMessageViewController ()<MessageViewDelegate>
{
    XHMessageClient *messageClient;
}
@property (nonatomic,strong)XHMessageListController *messageListControler;
@end

@implementation XHMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化消息容器messagesDict
    self.contactsMessages = [NSMutableArray array];
    messageClient = [XHMessageClient shareMessageClient];
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
    
    XHMessageViewTableCell *viewCell = [XHMessageViewTableCell messageViewCellWithTableView:tableView];
    
    viewCell.messageArrays = self.contactsMessages[indexPath.row];
    return viewCell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.messageListControler = [[XHMessageListController alloc]init];
    [self.navigationController pushViewController:self.messageListControler animated:YES];
    NSMutableArray *msgsArray = self.contactsMessages[indexPath.row];
    //将该cell对应的联系人信息传过去
    for (NSDictionary *contactDict in self.contacts) {
        XHContactModel *contactPerson = [XHContactModel contactWithDict:contactDict];
        if ([msgsArray[0][@"senderID"] isEqualToString:contactPerson.userID]) {
            self.messageListControler.contactPerson = contactPerson;
            break;
        }
    }
    for (int i =0; i<msgsArray.count-1; i++) {
        [self.messageListControler handleNewMessage:msgsArray[i]];
        if (i!=msgsArray.count-2) {
            [msgsArray removeObjectAtIndex:i];
        }
    }
    
}

#pragma mark - MessageViewDelegate
/**
 *将接收到的消息放在messageview里面的dict中
 *如果程序在后台
 */
-(void)showMessageView:(NSDictionary *)dict{
    //程序不在后台
    NSUInteger count = self.contactsMessages.count;
    XHLog(@"receive msg is %@",dict);
    XHLog(@"receive1 msg is %@",dict[@"senderID"]);
    
    if (count==0) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dict];
        [self.contactsMessages addObject:array];
    }else{
        for (int i =0; i<count; i++) {
            XHLog(@"i is %d",i);
            NSMutableArray *msgsArray = self.contactsMessages[i];
            XHChatBean *chatBean = [XHChatBean chatWithDict:msgsArray[0]];
            XHLog(@"msgArray is %@",chatBean.receiverID);
            XHLog(@"receive2 msg is %@",dict[@"senderID"]);
            if ([chatBean.senderID isEqualToString:dict[@"senderID"]]) {
                [msgsArray addObject:dict];
                break;
            }
            if (i==count-1) {
                NSMutableArray *array = [NSMutableArray array];
                [array addObject:dict];
                [self.contactsMessages addObject:array];
            }
        }
    }
    
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
