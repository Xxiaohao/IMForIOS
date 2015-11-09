//
//  CZMessageFrame.m
//  001QQ聊天界面
//
//  Created by apple on 15/3/4.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "XHMessageFrame.h"
#import "XHChatBean.h"
#import <UIKit/UIKit.h>
#import "NSString+XHNSStringExt.h"
#import "XHUserInfo.h"

@implementation XHMessageFrame


- (void)setChatBean:(XHChatBean *)chatBean
{
    _chatBean = chatBean;
    
    
    
    for (int i =0; i<_chatBean.msgFlagQueue.count; i++) {
        if ([_chatBean.msgFlagQueue[i] intValue]==0) {//文字
            
        }else if ([_chatBean.msgFlagQueue[i] intValue]==1){//图片
            [self setImageMsgFrameWithBean:_chatBean andIndex:i];
        }
    }
}

-(void)setImageMsgFrameWithBean:(XHChatBean *)chatBean andIndex:(NSInteger)i{
    // 计算每个控件的frame 和 行高
    // 获取屏幕宽度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    // 设置一个统一的间距
    CGFloat margin = 5;
    
    // 计算时间label的frame
    CGFloat timeX = 0;
    CGFloat timeY = 0;
    CGFloat timeW = screenW;
    CGFloat timeH = 15;
    if (!chatBean.hiddenTime) {
    // 如果需要显示时间label, 那么再计算时间label的frame
        _timeFrame = CGRectMake(timeX, timeY, timeW, timeH);
    }
    
    // 计算头像的frame
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    CGFloat iconY = CGRectGetMaxY(_timeFrame) + margin;
    CGFloat iconX = [[XHUserInfo sharedXHUserInfo].userID isEqualToString:chatBean.receiverID ]? margin : screenW - margin - iconW;
    _iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
//    NSData *data = [[NSData alloc]initWithBase64EncodedString:chatBean.msgQueue[i] options:nil];
//    // 计算消息正文的frame
//    UIImage *image = [UIImage imageWithData:data];
    // 1. 先计算正文的大小
//    CGSize textSize = [chatBean.msg sizeOfTextWithMaxSize:CGSizeMake(screenW-100, MAXFLOAT) font:textFont];
    CGSize textSize = CGSizeMake(100,100);
    CGFloat textW = textSize.width + 40;
    CGFloat textH = textSize.height + 30;
    // 2. 再计算x,y
    CGFloat textY = iconY;
    CGFloat textX = [[XHUserInfo sharedXHUserInfo].userID isEqualToString:chatBean.receiverID ] ? CGRectGetMaxX(_iconFrame) : (screenW - margin - iconW - textW);
    _textFrame = CGRectMake(textX, textY, textW, textH);
    
    // 计算行高
    // 获取 头像的最大的Y值和正文的最大的Y值, 然后用最大的Y值+ margin
    CGFloat maxY = MAX(CGRectGetMaxY(_textFrame), CGRectGetMaxY(_iconFrame));
    _rowHeight = maxY + margin;
}

-(void)setTextMsgFrameWithBean:(XHChatBean *)chatBean{
    
    // 计算每个控件的frame 和 行高
    // 获取屏幕宽度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    // 设置一个统一的间距
    CGFloat margin = 5;
    // 计算时间label的frame
    CGFloat timeX = 0;
    CGFloat timeY = 0;
    CGFloat timeW = screenW;
    CGFloat timeH = 15;
    if (!chatBean.hiddenTime) {
        //        // 如果需要显示时间label, 那么再计算时间label的frame
        _timeFrame = CGRectMake(timeX, timeY, timeW, timeH);
    }
    
    // 计算头像的frame
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    CGFloat iconY = CGRectGetMaxY(_timeFrame) + margin;
    CGFloat iconX = [[XHUserInfo sharedXHUserInfo].userID isEqualToString:chatBean.receiverID ]? margin : screenW - margin - iconW;
    _iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    // 计算消息正文的frame
    // 1. 先计算正文的大小
    CGSize textSize = [chatBean.msg sizeOfTextWithMaxSize:CGSizeMake(screenW-100, MAXFLOAT) font:textFont];
    CGFloat textW = textSize.width + 40;
    CGFloat textH = textSize.height + 30;
    // 2. 再计算x,y
    CGFloat textY = iconY;
    CGFloat textX = [[XHUserInfo sharedXHUserInfo].userID isEqualToString:chatBean.receiverID ] ? CGRectGetMaxX(_iconFrame) : (screenW - margin - iconW - textW);
    _textFrame = CGRectMake(textX, textY, textW, textH);
    
    // 计算行高
    // 获取 头像的最大的Y值和正文的最大的Y值, 然后用最大的Y值+ margin
    CGFloat maxY = MAX(CGRectGetMaxY(_textFrame), CGRectGetMaxY(_iconFrame));
    _rowHeight = maxY + margin;
}


@end
