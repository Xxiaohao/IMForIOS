//
//  XHEmotionView.m
//  IMForIOS
//
//  Created by LC on 15/11/16.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHEmotionPageView.h"
#import "XHEmotion.h"
#import "XHEmotionButton.h"
#import "MJExtension.h"

@interface XHEmotionPageView()

@property (nonatomic,strong)UIButton *deleteButton;

@end

@implementation XHEmotionPageView

//-(NSArray *)emotionArray{
//    }

//-(instancetype)initWithEmotionButton{
//    if (self = [super init]) {
//        CGFloat emotionWidth = 32;
//        CGFloat emotionHeight = 32;
//        CGFloat marginTop = 10;
//        CGFloat viewWidth = self.window.frame.size.width;
//        CGFloat viewHeight = 150;
//        
//        for (int i = 0; i<self.emotionArray.count ; i++) {
//            XHEmotionButton *emotionButton = [[XHEmotionButton alloc]init];
//            emotionButton.emotion = self.emotionArray[i];
//            CGFloat marginHor = (viewWidth-emotionWidth*7)/8 ;
//            CGFloat marginVer = (viewHeight - marginTop*2-emotionHeight*3)/2 ;
//            emotionButton.frame =CGRectMake(i%7*(marginHor+emotionWidth)+marginHor, i/7*(marginVer + emotionHeight)+marginTop, emotionWidth, emotionHeight);
//            [self addSubview:emotionButton];
//        }
//    }
//    return self;
//}


-(void)setEmotionArray:(NSArray *)emotionArray{
    _emotionArray = emotionArray;
    
    CGFloat emotionWidth = 32;
    CGFloat emotionHeight = 32;
    CGFloat marginTop = 10;
    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = 130;
    CGFloat marginHor = (viewWidth-emotionWidth*EmotionMaxCols)/(EmotionMaxCols+1) ;
    CGFloat marginVer = (viewHeight - marginTop*(EmotionMaxRows-1)-emotionHeight*EmotionMaxRows)/(EmotionMaxRows-1) ;
    
//    XHLog(@" view width is %f",viewWidth);
    for (int i = 0; i<_emotionArray.count ; i++) {
        XHEmotionButton *emotionButton = [[XHEmotionButton alloc]init];
        emotionButton.emotion = self.emotionArray[i];
        [emotionButton addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
        [emotionButton setImage:[UIImage imageNamed:emotionButton.emotion.png] forState:UIControlStateNormal];
        emotionButton.frame =CGRectMake(i%EmotionMaxCols*(marginHor+emotionWidth)+marginHor, i/EmotionMaxCols*(marginVer + emotionHeight)+marginTop, emotionWidth, emotionHeight);
        [self addSubview:emotionButton];
    }
    UIButton *deleteButton = [[UIButton alloc] init];
    [deleteButton setImage:[UIImage imageNamed:@"chat_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
    [deleteButton setImage:[UIImage imageNamed:@"chat_emotion_delete"] forState:UIControlStateNormal];
    deleteButton.frame =CGRectMake(_emotionArray.count%EmotionMaxCols*(marginHor+emotionWidth)+marginHor, _emotionArray.count/EmotionMaxCols*(marginVer + emotionHeight)+marginTop, emotionWidth, emotionHeight);
    [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    self.deleteButton = deleteButton;
    
    // 2.添加长按手势
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPageView:)]];
}

-(void)emotionClick:(XHEmotionButton *)emotionButton{
//    emotionButton.emotion;
    NSDictionary *dict = emotionButton.emotion.keyValues;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"chooseEmotionNotification" object:nil userInfo:dict];
    
}

-(void)deleteClick{

}

-(void)longPressPageView:(UILongPressGestureRecognizer *)recognizer{

}

-(void)layoutSubviews{
    [super layoutSubviews];
//    XHLog(@"----layoutSubviews-----");
}

@end
