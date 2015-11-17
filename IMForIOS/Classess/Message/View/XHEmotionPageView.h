//
//  XHEmotionView.h
//  IMForIOS
//
//  Created by LC on 15/11/16.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EmotionMaxRows 3
#define EmotionMaxCols 7
#define EmotionPageCount (EmotionMaxRows * EmotionMaxCols-1)

@interface XHEmotionPageView : UIView

@property (nonatomic,strong) NSArray *emotionArray;

@end
