//
//  XHChatBean.m
//  IMForIOS
//
//  Created by LC on 15/10/12.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHChatBean.h"

@implementation XHChatBean

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        XHLog(@"---arc4random%d---",arc4random_uniform(2)) ;
        self.userID = [NSString stringWithFormat:@"%d",arc4random_uniform(2)];
        self.senderID = [NSString stringWithFormat:@"%d",arc4random_uniform(2)];
        self.receiverID = [NSString stringWithFormat:@"%d",arc4random_uniform(2)];
        self.indexs = [NSString stringWithFormat:@"%d",arc4random_uniform(2)];
        self.msg = dict[@"text"];
        self.time = dict[@"time"];
//        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)chatWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

@end
