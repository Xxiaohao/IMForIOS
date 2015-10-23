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
{
    XHMessageClient *messageClient;
}
@property (nonatomic,strong)XHMessageListController *messageListControler;
@end

@implementation XHMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    for (NSDictionary *contactDict in self.contacts) {
        XHContactModel *contactPerson = [XHContactModel contactWithDict:contactDict];
        if ([dict[@"senderID"] isEqualToString:contactPerson.userID]) {
            self.messageListControler.contactPerson = contactPerson;
            break;
        }
    }
    [self.messageListControler handleNewMessage:dict];
}


//-(void)didEndConnectToMessageServer{
//    XHLog(@"-----didEndConnectToMessageServer--");
//    NSDictionary *chatBeanDict = [[NSDictionary alloc]initWithObjectsAndKeys:@"184211",@"userID",@"",@"senderID",@"",@"receiverID",@"",@"AUDIO_SAMPLE_RATE",@"",@"AUDIO_SAMPLE_SIZE_IN_BITS",@"",@"AUDIO_CHANNELS",@[],@"msgFlagQueue",@[],@"msgQueue",@"",@"msg",@"",@"indexs",@"",@"time", nil];
//    [messageClient sendingDataWithCommandID:@"130" andCommandResult:@"-1" andCommandContent:chatBeanDict];
//}

-(void)channelActive{
    NSDictionary *chatBeanDict = [[NSDictionary alloc]initWithObjectsAndKeys:@"184211",@"userID",@"",@"senderID",@"",@"receiverID",@"",@"AUDIO_SAMPLE_RATE",@"",@"AUDIO_SAMPLE_SIZE_IN_BITS",@"",@"AUDIO_CHANNELS",@[],@"msgFlagQueue",@[],@"msgQueue",@"",@"msg",@"",@"indexs",@"",@"time", nil];
    [messageClient sendingDataWithCommandID:@"110" andCommandResult:@"-1" andCommandContent:chatBeanDict];
}
















@end
