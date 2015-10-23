//
//  XHAsyncSocketClient.m
//  IMForIOS
//
//  Created by LC on 15/9/17.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHAsyncSocketClient.h"

@interface XHAsyncSocketClient(){
    SessionServerBlock _resultSessionServerBolck;
}

@end

@implementation XHAsyncSocketClient

static XHAsyncSocketClient *socketClient=nil;

+(XHAsyncSocketClient *)shareSocketClient{
    @synchronized(self){
        if (!socketClient) {
            socketClient = [[[self class] alloc]init];
        }
    }
    return socketClient;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (socketClient == nil)
        {
            socketClient = [super allocWithZone:zone];
            return socketClient;
        }
    }
    return nil;
}

//建立长连接
- (void)startConnectSocket
{
    self.socket = [[AsyncSocket alloc] initWithDelegate:self];
    [self.socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    if (![self SocketOpen:SESSION_SERVER_IP port:SESSION_SERVER_PORT] )
    {

    }
    
}

- (NSInteger)SocketOpen:(NSString*)addr port:(NSInteger)port
{
    
    if (![self.socket isConnected])
    {
        NSError *error = nil;
        if (![self.socket connectToHost:addr onPort:port withTimeout:TIME_OUT error:&error]) {
            NSLog(@"error---%@",error);
        };
    }
    return 0;
}


- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    //这是异步返回的连接成功，
    NSLog(@"didConnectSessionServerToHost %@：%d",host,port);
    
//    //通过定时器不断发送消息，来检测长连接
//    self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkLongConnectByServe) userInfo:nil repeats:YES];
//    [self.heartTimer fire];
}

// 心跳连接
-(void)checkLongConnectByServe{
    
    // 向服务器发送固定可是的消息，来检测长连接
    NSString *longConnect = @"connect is here";
    NSData   *data  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:10 tag:1];
}

-(void)cutOffSocket
{
    self.socket.userData = SocketOfflineByUser;
    [self.socket disconnect];
}

//- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
//{
//
//    NSLog(@" willDisconnectWithError %ld   err = %@",sock.userData,[err description]);
//    if (err.code == 57) {
//        self.socket.userData = SocketOfflineByWifiCut;
//    }
//
//}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    
    NSLog(@"7878 sorry the connect is failure %ld",sock.userData);
    
    if (sock.userData == SocketOfflineByServer) {
        // 服务器掉线，重连
        [self startConnectSocket];
    }
    else if (sock.userData == SocketOfflineByUser) {
        
        // 如果由用户断开，不进行重连
        return;
    }else if (sock.userData == SocketOfflineByWifiCut) {
        
        // wifi断开，不进行重连
        return;
    }
}


//发送消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"消息发送成功");
    //读取消息
//    [self.socket readDataWithTimeout:-1 tag:0];
    [self.socket readDataWithTimeout:READ_TIME_OUT buffer:self.allData bufferOffset:self.allData.length maxLength:MAX_BUFFER tag:0];
}

//接受消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    //服务端返回消息数据量比较大时，可能分多次返回。所以在读取消息的时候，设置MAX_BUFFER表示每次最多读取多少，当data.length < MAX_BUFFER我们认为有可能是接受完一个完整的消息，然后才解析
//当length>8的时候  我们认为可能有一条完整的消息过来了
    if (self.allData.length >8) {
        [self handleBufferData];
    }
    [self.socket readDataWithTimeout:READ_TIME_OUT buffer:self.allData bufferOffset:self.allData.length maxLength:MAX_BUFFER tag:0];
    //解析出来的消息，可以通过通知、代理、block等传出去
}

-(void)handleBufferData{
    //这个data是一个int数据，存放的是java服务端netty发送过来的数据的长度
    NSData *contentData = [self.allData subdataWithRange:NSMakeRange(4, 4)];
    NSInteger contentDataNetLength;
    memcpy(&contentDataNetLength, [contentData bytes], sizeof(int));
    NSInteger contentDataLocalLength = ntohl(contentDataNetLength);
//    NSLog(@"--self.allData.length is -2--%ld--contentDataLength-%ld-",self.allData.length,contentDataLocalLength);
    //如果data的长度大于发送过来的长度contentDataNetLength+8，证明data中包含了发送过来的一整条消息
    if(self.allData.length>=(contentDataLocalLength+8)){
        NSRange readRange = NSMakeRange(8, contentDataLocalLength);
        NSData *contentData = [self.allData subdataWithRange:readRange];
//        NSString *content = [[NSString alloc]initWithData:contentData encoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingMutableLeaves error:nil];
        [self handleDataWithDict:dic];
        //将已经操作过的数据移除
        [self.allData replaceBytesInRange:NSMakeRange(0, contentDataLocalLength+8) withBytes:nil length:0];
        //如果data读取过后，数据长度仍然大于8，则有可能data中还包含了一条消息
        if (self.allData.length>8) {
            [self handleBufferData];
        }
    }
}

#pragma mark 消息处理
-(void)handleDataWithDict:(NSDictionary *)dic{
    NSString *commandContent= [dic objectForKey:@"commandContent"];
    NSString *commandID = [dic objectForKey:@"commandID"];
    NSString *commandResult = [dic objectForKey:@"commandResult"];
    NSDictionary *contentDic = [NSJSONSerialization JSONObjectWithData:[commandContent dataUsingEncoding:NSUTF8StringEncoding ] options:NSJSONReadingMutableLeaves error:nil];
//    BOOL flag = ([commandResult intValue]==8);
    XHLog(@"-------result is %@----",commandResult);
    switch ([commandID intValue]) {
        case 0:
        {
            if ([commandResult intValue]==LOGIN_SECCUSS) {
                XHLog(@"--登录成功--%@--",[NSThread currentThread]);
                _resultSessionServerBolck(LOGIN_SECCUSS,contentDic);
            }else if ([commandResult intValue]==8) {
//                [self.sessionServerDelegate showFriendsWithDict:contentDic];
//                XHLog(@"%@",contentDic);
                _resultSessionServerBolck(8,contentDic);
            }else if([commandResult intValue] == 9){
                _resultSessionServerBolck(9,contentDic);
                [self.sessionServerDelegate searchContacts:contentDic];
            }
        }
            break;
            
    }
    
}
#pragma mark 将要断开
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSData * unreadData = [sock unreadData]; // ** This gets the current buffer
    if(unreadData.length > 0) {
        [self onSocket:sock didReadData:unreadData withTag:0]; // ** Return as much data that could be collected
    } else {
        
        NSLog(@" willDisconnectWithError %ld   err = %@",sock.userData,[err description]);
        if (err.code == 57) {
            self.socket.userData = SocketOfflineByWifiCut;
        }
    }
}

-(void)loginWithUserName:(NSString *)userName andUserPW:(NSString *)userPw andBlock:(SessionServerBlock)returnBlock{
    //网络连接
//        self.socketClient = [XHAsyncSocketClient shareSocketClient ];
        //socket连接前先断开连接以免之前socket连接没有断开导致闪退
        [self cutOffSocket];
        self.socket.userData = SocketOfflineByServer;
        [self startConnectSocket];
        self.allData = [[NSMutableData alloc]init];
    if (!_resultSessionServerBolck) {
        _resultSessionServerBolck = returnBlock;
    }
    NSDictionary *commandContent = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"userID",userPw,@"userPassword",@"2",@"loginFlag", nil];
    [self sendingDataWithCommandID:@"0" andCommandResult:@"-1" andCommandContent:commandContent];
}

/**
 *对要发送的数据进行封装再发送
 */
- (void)sendingDataWithCommandID:(NSString *)commandID andCommandResult :(NSString *)commandResult andCommandContent:(NSDictionary *)commandContent{
    
    NSError *err = nil;
    NSMutableDictionary *JsonDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:commandID,@"commandID" ,commandResult,@"commandResult",commandContent,@"commandContent",nil];
    
    NSData *JsonString = [NSJSONSerialization dataWithJSONObject:JsonDic options:NSJSONWritingPrettyPrinted error:&err];  //Json的输入参数必须为NSArray或者NSDictionary
//    NSLog(@"所发送的Json为：%@",[[NSString alloc] initWithData: JsonString encoding:NSUTF8StringEncoding]);
    
    unsigned int datalength = (unsigned int)JsonString.length;
    unsigned int datatotallength = datalength + 4;
    
    uint32_t theInt = htonl((uint32_t)datalength);
    uint32_t theTotalInt = htonl((uint32_t)datatotallength);
    
    NSData *lengthData = [[NSData alloc] initWithBytes:&theInt length:sizeof(int)];
    NSData *lengthTotalData = [[NSData alloc] initWithBytes:&theTotalInt length:sizeof(int)];
    NSMutableData *sendingData = [NSMutableData alloc];
    //发送两个长度，第一个是总长度，猜测就是netty默认会解析这么长的数据。第二个就是自己去解析所带的内容
    [sendingData appendData:lengthTotalData];
    [sendingData appendData:lengthData];
    [sendingData appendData:JsonString];
    //NSLog(@"发送出的数据为：%@",sendingData);
    [self.socket writeData:sendingData withTimeout:WRITE_TIME_OUT tag:1];
}

@end
