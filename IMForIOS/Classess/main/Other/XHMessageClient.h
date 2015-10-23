//
//  XHMessageClient.h
//  IMForIOS
//
//  Created by LC on 15/10/12.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "XHMessageViewController.h"


enum{
    SocketOfflineByServer,      //服务器掉线
    SocketOfflineByUser,        //用户断开
    SocketOfflineByWifiCut,     //wifi 断开
};

@protocol MessageViewDelegate <NSObject>

-(void)showMessageView:(NSDictionary *)dict;
-(void)didEndConnectToMessageServer;

@end

@interface XHMessageClient : NSObject<AsyncSocketDelegate>

@property (nonatomic,strong) AsyncSocket *socket;
@property (nonatomic,retain) NSTimer *heartTimer;
@property (nonatomic,strong) NSMutableData *allData;
@property (nonatomic,assign)id<MessageViewDelegate> messageViewDelegate;


+(XHMessageClient *)shareMessageClient;

//长连接
- (void)startConnectSocket;

// 断开socket连接
-(void)cutOffSocket;

// 发送消息
- (void)sendingDataWithCommandID:(NSString *)commandID andCommandResult :(NSString *)commandResult andCommandContent:(NSDictionary *)commandContent;
@end
