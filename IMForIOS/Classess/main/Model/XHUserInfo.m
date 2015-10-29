//
//  XHUserInfo.m
//  IMForIOS
//
//  Created by LC on 15/10/21.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHUserInfo.h"

#define UserKey @"userID"
#define PasswordKey @"password"

@implementation XHUserInfo

singleton_implementation(XHUserInfo);

-(void)loadUserInfoFromSanbox{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.userID = [userDefaults objectForKey:UserKey];
    self.passWord =[userDefaults objectForKey:PasswordKey];
    self.userName = [userDefaults objectForKey:@"userName"];
    self.userSex = [[userDefaults objectForKey:@"userSex"] intValue];
    self.userAge = [[userDefaults objectForKey:@"userAge"] intValue];
    
    self.userDuty = [userDefaults objectForKey:@"userDuty"];
    self.userIP = [userDefaults objectForKey:@"userIP"];
    self.userSignature = [userDefaults objectForKey:@"userSignature"];
    self.userStatus = [userDefaults objectForKey:@"userStatus"];
    self.userUnit = [userDefaults objectForKey:@"userUnit"];
    self.upheadspe = [[userDefaults objectForKey:@"upheadspe"]intValue];
    
    self.allFatherNum = [userDefaults objectForKey:@"allFatherNum"];
    self.allFatherString = [userDefaults objectForKey:@"allFatherString"];
    self.loginFlag = [userDefaults objectForKey:@"loginFlag"];
    self.namePinyin = [userDefaults objectForKey:@"namePinyin"];
    self.nameShortPinyin = [userDefaults objectForKey:@"nameShortPinyin"];
    self.nickName = [userDefaults objectForKey:@"nickName"];
    
    
}

-(void)saveUserInfoToSanbox{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.userID forKey:UserKey];
    [userDefaults setObject:self.passWord forKey:PasswordKey];
    [userDefaults setObject:self.userName forKey:@"userName"];
    [userDefaults setObject:@(self.userSex) forKey:@"userSex"];
    [userDefaults setObject:@(self.userAge) forKey:@"userAge"];
    
    [userDefaults setObject:self.userDuty forKey:@"userDuty"];
    [userDefaults setObject:self.userIP forKey:@"userIP"];
    [userDefaults setObject:self.userSignature forKey:@"userSignature"];
    [userDefaults setObject:self.userStatus forKey:@"userStatus"];
    [userDefaults setObject:self.userUnit forKey:@"userUnit"];
    [userDefaults setObject:@(self.upheadspe) forKey:@"upheadspe"];

    [userDefaults setObject:self.allFatherNum forKey:@"allFatherNum"];
    [userDefaults setObject:self.allFatherString forKey:@"allFatherString"];
    [userDefaults setObject:self.loginFlag forKey:@"loginFlag"];
    [userDefaults setObject:self.namePinyin forKey:@"namePinyin"];
    [userDefaults setObject:self.nameShortPinyin forKey:@"nameShortPinyin"];
    [userDefaults setObject:self.nickName forKey:@"nickName"];

    [userDefaults setObject:self.msgViewArray forKey:@"msgViewArray"];
    
    [userDefaults synchronize];
}

-(void)saveMsgViewArrayInToSanbox{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.msgViewArray forKey:@"msgViewArray"];
    [userDefaults synchronize];
}

@end
