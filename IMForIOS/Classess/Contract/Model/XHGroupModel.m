//
//  XHGroupModel.m
//  IMForIOS
//
//  Created by LC on 15/10/12.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHGroupModel.h"

@implementation XHGroupModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.groupID = [dict[@"groupId"] intValue];
        self.createTime = dict[@"createTime"];
        self.creatorID = dict[@"creatorId"];
        self.groupName = dict[@"groupName"];
//        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)groupWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

@end
