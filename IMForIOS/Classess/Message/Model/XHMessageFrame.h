//
//  CZMessageFrame.h
//  001QQ聊天界面
//
//  Created by apple on 15/3/4.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#define textFont [UIFont systemFontOfSize:13]

@class XHChatBean;
@interface XHMessageFrame : NSObject

// 引用数据模型
@property (nonatomic, strong) XHChatBean *chatBean;

// 时间Label的frame
@property (nonatomic, assign, readonly) CGRect timeFrame;

// 头像的frame
@property (nonatomic, assign, readonly) CGRect iconFrame;

// 正文的frame
@property (nonatomic, assign, readonly) CGRect textFrame;

// 行高
@property (nonatomic, assign, readonly) CGFloat rowHeight;

@end
