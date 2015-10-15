//
//  XHAsyncSocketClient.h
//  IMForIOS
//
//  Created by LC on 15/9/17.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"


enum{
    SocketOfflineByServer,      //服务器掉线
    SocketOfflineByUser,        //用户断开
    SocketOfflineByWifiCut,     //wifi 断开
};

@interface XHAsyncSocketClient : NSObject<AsyncSocketDelegate>
@property (nonatomic,strong) AsyncSocket *socket;
@property (nonatomic,retain) NSTimer *heartTimer;
@property (nonatomic,strong) NSMutableData *allData;
//@property (nonatomic,strong)NSArray *friends;

+(XHAsyncSocketClient *)shareSocketClient;

//长连接
- (void)startConnectSocket;

// 断开socket连接
-(void)cutOffSocket;

// 发送消息
- (void)sendMessage:(id)message;
@end