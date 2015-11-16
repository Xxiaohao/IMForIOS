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
#import "TYImageCache.h"

@implementation XHMessageFrame


- (void)setChatBean:(XHChatBean *)chatBean
{
    _chatBean = chatBean;
    
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
    
    //计算消息的所有片段的frame。取得所有消息片段的高度，然后相加得到消息的总高度。取得所有消息片段的长度，取最长的长度作为总长度
    CGFloat subButtonX = 20;
    CGFloat subButtonY = 15;
    CGFloat totalWidth =0;
    CGFloat totalHight= 0;
    NSArray *indexArray = [chatBean.indexs componentsSeparatedByString:@","];
    NSString *totalMsg = chatBean.msg;
    for (int i=0; i<indexArray.count-1; i++) {
        
        if (self.subContentArray == nil) {
            self.subContentArray = [NSMutableArray array];
        }
        
        NSString *msgFlag = [indexArray[i] substringToIndex:1];
        NSInteger length = [[indexArray[i] substringFromIndex:1]intValue];
//        XHLog(@"-msgflag is %@-and length is %ld-",msgFlag,length);
        CGSize previewSize = CGSizeZero;
        if ([msgFlag intValue]==0) {
            NSString *textMsg =[totalMsg substringToIndex:length];
            totalMsg = [totalMsg substringFromIndex:length];
//            XHLog(@"-textMsg is %@-and totalMsg is %@-",textMsg,totalMsg);
            previewSize = [textMsg sizeOfTextWithMaxSize:CGSizeMake(screenW-100, MAXFLOAT) font:textFont];
        }else if ([msgFlag intValue]==1){
            // 计算消息正文的frame
            NSString *imageMsg =[totalMsg substringToIndex:length];
            totalMsg = [totalMsg substringFromIndex:length];
            NSString *path = [[TYImageCache cache].localDirectory stringByAppendingPathComponent:imageMsg];
//            XHLog(@"-textMsg is %@-and totalMsg is %@-",imageMsg,totalMsg);
            UIImage *img =[[UIImage alloc]initWithContentsOfFile:path];
            if (img.size.width>screenW-140||img.size.height>screenW-140) {
                CGFloat scaleWidth = img.size.width/(screenW-140);
                CGFloat scaleHeight = img.size.height/(screenW-140);
                if (scaleWidth>scaleHeight) {
                    previewSize = CGSizeMake(img.size.width/scaleWidth, img.size.height/scaleWidth);
                }else{
                    previewSize = CGSizeMake(img.size.width/scaleHeight, img.size.height/scaleHeight);
                }
            }else{
                previewSize = img.size;
            }
        }
//        XHLog(@"-----------------------------------subButtonY is %f------------------------------------",subButtonY);
        [self.subContentArray addObject:[NSValue valueWithCGRect:CGRectMake(subButtonX, subButtonY, previewSize.width, previewSize.height)]];
        subButtonY +=previewSize.height;
        totalHight +=previewSize.height;
        if (totalWidth<previewSize.width) {
            totalWidth = previewSize.width;
        }
        
    }
    CGSize textSize = CGSizeMake(totalWidth,totalHight);
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
    XHLog(@"-------------setTextMsgFrameWithBean-------------------");
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


@end
