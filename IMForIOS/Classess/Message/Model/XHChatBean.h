//
//  XHChatBean.h
//  IMForIOS
//
//  Created by LC on 15/10/12.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHChatBean : NSObject

@property (nonatomic,copy)NSString *userID;
@property (nonatomic,copy)NSString *senderID;
@property (nonatomic,copy)NSString *receiverID;
@property (nonatomic,strong)NSArray *msgFlagQueue;//对消息片段的标示
@property (nonatomic,strong)NSArray *msgQueue;//消息片段
@property (nonatomic,copy)NSString *msg;
@property (nonatomic,copy)NSString *indexs;
@property (nonatomic,copy)NSString *time;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)chatWithDict:(NSDictionary *)dict;

@end
