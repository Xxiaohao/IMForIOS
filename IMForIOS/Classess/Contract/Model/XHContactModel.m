//
//  XHContactModel.m
//  IMForIOS
//
//  Created by LC on 15/9/17.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHContactModel.h"

@implementation XHContactModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
//        self.nickName=dict[@"nickName"];
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)contactWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

@end
