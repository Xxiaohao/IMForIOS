//
//  XHEmotion.h
//  IMForIOS
//
//  Created by LC on 15/11/16.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHEmotion : UIView

/** 表情的文字描述 */
@property (nonatomic, copy) NSString *chs;
/** 表情的png图片名 */
@property (nonatomic, copy) NSString *png;
/** emoji表情的16进制编码 */
//@property (nonatomic, copy) NSString *code;

-(instancetype)initWithDic:(NSDictionary *)dict;
+(instancetype)emotionWithDic:(NSDictionary *)dict;

@end
