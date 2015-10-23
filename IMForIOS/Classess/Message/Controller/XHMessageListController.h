//
//  XHMessageListController.h
//  IMForIOS
//
//  Created by LC on 15/10/12.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHContactModel.h"
#import <UIKit/UIKit.h>

@interface XHMessageListController : UIViewController

@property (nonatomic,strong) NSMutableArray *messageFrames;
@property (nonatomic,strong) XHContactModel *contactPerson;

//对接收到的消息进行处理
-(void)handleNewMessage:(NSDictionary *)dict;

@end
