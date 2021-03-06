//
//  XHMessageClient.m
//  IMForIOS
//
//  Created by LC on 15/10/12.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHMessageClient.h"



@implementation XHMessageClient

singleton_implementation(XHMessageClient);

static XHMessageClient *messageClient=nil;

//+(XHMessageClient *)shareMessageClient{
//    @synchronized(self){
//        if (!messageClient) {
//            messageClient = [[[self class] alloc]init];
//        }
//    }
//    return messageClient;
//}
//
//+(id)allocWithZone:(NSZone *)zone
//{
//    @synchronized(self)
//    {
//        if (messageClient == nil)
//        {
//            messageClient = [super allocWithZone:zone];
//            return messageClient;
//        }
//    }
//    return nil;
//}

//建立长连接
- (void)startConnectSocket
{
    self.socket = [[AsyncSocket alloc] initWithDelegate:self];
    XHLog(@"---self.socket isConnected -1---" );
//    [self.socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    if ([self SocketOpen:MESSAGE_SERVER_IP port:MESSAGE_SERVER_PORT] )
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
        }
    }
    return 1;
}


- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    //这是异步返回的连接成功，
    NSLog(@"didConnectToMessageServerHost %@：%d",host,port);
//    [self.socket readDataWithTimeout:READ_TIME_OUT buffer:self.allData bufferOffset:self.allData.length maxLength:MAX_BUFFER tag:0];
    
    //    //通过定时器不断发送消息，来检测长连接
    //    self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkLongConnectByServe) userInfo:nil repeats:YES];
    //    [self.heartTimer fire];
}

// 心跳连接
//-(void)checkLongConnectByServe{
//    
//    // 向服务器发送固定可是的消息，来检测长连接
//    NSString *longConnect = @"connect is here";
//    NSData   *data  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
//    [self.socket writeData:data withTimeout:10 tag:1];
//}

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
//    [self.socket readDataWithTimeout:READ_TIME_OUT buffer:self.allData bufferOffset:self.allData.length maxLength:MAX_BUFFER tag:0];
}

//接受消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    XHLog(@"-----self.allData.length is %ld------",self.allData.length);
    if (self.allData.length >8) {
        [self handleBufferData];
    }
    [self.socket readDataWithTimeout:READ_TIME_OUT buffer:self.allData bufferOffset:self.allData.length maxLength:MAX_BUFFER tag:0];
}

-(void)handleBufferData{
    NSData *contentData = [self.allData subdataWithRange:NSMakeRange(4, 4)];
    NSInteger contentDataNetLength;
    memcpy(&contentDataNetLength, [contentData bytes], sizeof(int));
    NSInteger contentDataLocalLength = ntohl(contentDataNetLength);
    NSLog(@"--self.allData.length is -2--%ld--contentDataLength-%ld-",self.allData.length,contentDataLocalLength);
    if(self.allData.length>=(contentDataLocalLength+8)){
        NSRange readRange = NSMakeRange(8, contentDataLocalLength);
        NSData *contentData = [self.allData subdataWithRange:readRange];
//        NSString *content = [[NSString alloc]initWithData:contentData encoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingMutableLeaves error:nil];
        [self handleDataWithDict:dic];

        [self.allData replaceBytesInRange:NSMakeRange(0, contentDataLocalLength+8) withBytes:nil length:0];
        if (self.allData.length>8) {
            [self handleBufferData];
        }
    }
}

#pragma mark 消息处理
/**
 *主要接受来自客户端的消息，一直在线且网络状况良好的情况下是一条，突然上线则可能有多条消息
 */
-(void)handleDataWithDict:(NSDictionary *)dic{
    NSString *commandContent= [dic objectForKey:@"commandContent"];
    NSString *commandID = [dic objectForKey:@"commandID"];
    NSString *commandResult = [dic objectForKey:@"commandResult"];
    NSMutableDictionary *contentDic = [NSJSONSerialization JSONObjectWithData:[commandContent dataUsingEncoding:NSUTF8StringEncoding ] options:NSJSONReadingMutableLeaves error:nil];
    XHLog(@"-------result is %@----",commandResult);
    switch ([commandID intValue]) {
        case 120:
        {
            [self.messageViewDelegate showMessageView:contentDic];
        }
            break;
    }
    
}


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

#pragma mark 用户方法
-(void)channelActiveWithCommandContent:(NSString *)commandContent{
    //打开与消息服务器的网络连接
    XHLog(@"active---------------------");
    [self cutOffSocket];
    self.socket.userData = SocketOfflineByServer;
    [self startConnectSocket];
    self.allData = [[NSMutableData alloc]init];
    
    [self sendingDataWithCommandID:@"110" andCommandResult:@"-1" andCommandContent:commandContent];
    [self.socket readDataWithTimeout:READ_TIME_OUT buffer:self.allData bufferOffset:self.allData.length maxLength:MAX_BUFFER tag:0];
}

-(void)channelINActiveWithCommandContent:(NSString *)commandContent{
    [self sendingDataWithCommandID:@"130" andCommandResult:@"-1" andCommandContent:commandContent];
}



/**
 *对要发送的数据进行封装再发送
 */
- (void)sendingDataWithCommandID:(NSString *)commandID andCommandResult :(NSString *)commandResult andCommandContent:(NSString *)commandContent{
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:commandID,@"commandID" ,commandResult,@"commandResult",commandContent,@"commandContent",nil];
//    NSData *JsonString = [NSJSONSerialization dataWithJSONObject:JsonDic options:NSJSONWritingPrettyPrinted error:&err];  //Json的输入参数必须为NSArray或者NSDictionary
    NSData *jsonString = [jsonDic JSONData];
//    NSLog(@"所发送的Json为：%@",jsonDic);
    
    unsigned int datalength = (unsigned int)jsonString.length;
    unsigned int datatotallength = datalength + 4;
//    NSLog(@"传递的数据长度为：%u int的长度为%ld",datalength,sizeof(int));
    
    uint32_t theInt = htonl((uint32_t)datalength);
    uint32_t theTotalInt = htonl((uint32_t)datatotallength);
    
    NSData *lengthData = [[NSData alloc] initWithBytes:&theInt length:sizeof(int)];
    NSData *lengthTotalData = [[NSData alloc] initWithBytes:&theTotalInt length:sizeof(int)];
    NSMutableData *sendingData = [NSMutableData alloc];
    //发送两个长度，第一个是总长度，猜测就是netty默认会解析这么长的数据。第二个就是自己去解析所带的内容
    [sendingData appendData:lengthTotalData];
    [sendingData appendData:lengthData];
    [sendingData appendData:jsonString];
    //NSLog(@"发送出的数据为：%@",sendingData);
    [self.socket writeData:sendingData withTimeout:WRITE_TIME_OUT tag:1];
}


@end
