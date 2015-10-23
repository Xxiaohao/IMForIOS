//
//  XHContactModel.h
//  IMForIOS
//
//  Created by LC on 15/9/17.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHContactModel : NSObject


@property (nonatomic,copy)NSString *userID;//用户账号
@property (nonatomic,copy)NSString *userName;//用户姓名
@property (nonatomic,copy)NSString *userPassword;//用户密码
@property (nonatomic,copy)NSString *nickName;//用户昵称
@property (nonatomic,assign)int userSex;//用户性别
@property (nonatomic,assign)int userAge;//用户年龄
@property (nonatomic,copy)NSString *userUnit;//用户单位
@property (nonatomic,copy)NSString *userDuty;//用户职务
@property (nonatomic,copy)NSString *userSignature;//用户签名
@property (nonatomic,assign)int userStatus;//用户登录状态
@property (nonatomic,copy)NSString *userIP;//客户端IP
@property (nonatomic,assign)int loginFlag;//账号登陆标志位
@property (nonatomic,assign)int upheadspe;//头像
//@property (nonatomic,copy)NSString *contactsVersion;//联系人版本

-(instancetype)initWithDict:(NSDictionary *)dict;

+(instancetype)contactWithDict:(NSDictionary *)dict;

@end
