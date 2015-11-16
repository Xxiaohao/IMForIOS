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
#import "Singleton.h"

enum{
    SocketOfflineByServer,      //服务器掉线
    SocketOfflineByUser,        //用户断开
    SocketOfflineByWifiCut,     //wifi 断开
};

@protocol MessageViewDelegate <NSObject>

-(void)showMessageView:(NSMutableDictionary *)dict;
-(void)didEndConnectToMessageServer;

@end

@interface XHMessageClient : NSObject<AsyncSocketDelegate>

@property (nonatomic,strong) AsyncSocket *socket;
@property (nonatomic,retain) NSTimer *heartTimer;
@property (nonatomic,strong) NSMutableData *allData;
@property (nonatomic,assign)id<MessageViewDelegate> messageViewDelegate;

singleton_interface(XHMessageClient);

//+(XHMessageClient *)shareMessageClient;

//长连接
- (void)startConnectSocket;

// 断开socket连接
-(void)cutOffSocket;

// 发送消息
- (void)sendingDataWithCommandID:(NSString *)commandID andCommandResult :(NSString *)commandResult andCommandContent:(NSString *)commandContent;

/**第一次连接上消息服务器 相当于在消息服务器上面注册 */
-(void)channelActiveWithCommandContent:(NSString *)commandContent;

/**与消息服务器断开连接 相当于从消息服务器上面注销 */
-(void)channelINActiveWithCommandContent:(NSString *)commandContent;



@end
