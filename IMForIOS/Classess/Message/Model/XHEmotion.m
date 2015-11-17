//
//  XHEmotion.m
//  IMForIOS
//
//  Created by LC on 15/11/16.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHEmotion.h"
#import "MJExtension.h"

@implementation XHEmotion

-(instancetype)initWithDic:(NSDictionary *)dict{
    if (self = [super init]) {
        self = [XHEmotion objectWithKeyValues:dict];
    }
    return self;
}

+(instancetype)emotionWithDic:(NSDictionary *)dict{
    return  [[self alloc]initWithDic:dict];
}


@end
