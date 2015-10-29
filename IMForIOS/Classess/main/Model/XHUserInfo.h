//
//  XHUserInfo.h
//  IMForIOS
//
//  Created by LC on 15/10/21.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface XHUserInfo : NSObject

singleton_interface(XHUserInfo);

@property (nonatomic,copy)NSString *userID;
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,copy)NSString *passWord;
@property (nonatomic,assign)int userSex;
@property (nonatomic,assign)int userAge;

@property (nonatomic,copy)NSString *userDuty;
@property (nonatomic,copy)NSString *userIP;
@property (nonatomic,copy)NSString *userSignature;
@property (nonatomic,copy)NSString *userStatus;
@property (nonatomic,copy)NSString *userUnit;
@property (nonatomic,assign)int upheadspe;

@property (nonatomic,copy)NSString *allFatherNum;
@property (nonatomic,copy)NSString *allFatherString;
@property (nonatomic,copy)NSString *loginFlag;
@property (nonatomic,copy)NSString *namePinyin;
@property (nonatomic,copy)NSString *nameShortPinyin;
@property (nonatomic,copy)NSString *nickName;

@property (nonatomic,strong)NSMutableArray *msgViewArray;

/**
 *从沙盒获取用户数据
 */
-(void)loadUserInfoFromSanbox;
/**
 *保存数据到沙盒
 */
-(void)saveUserInfoToSanbox;

/**将msgViewArray放入沙盒 */
-(void)saveMsgViewArrayInToSanbox;
@end
