//
//  XHEmotionListView.m
//  IMForIOS
//
//  Created by LC on 15/11/16.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHEmotionListView.h"
#import "XHEmotionPageView.h"
#import "XHEmotion.h"

@interface XHEmotionListView()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) UIPageControl *pageControl;

@end

@implementation XHEmotionListView

-(NSArray *)emotionArray{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"defaultEmotion" ofType:@"plist"];
    NSArray *array = [[NSArray alloc]initWithContentsOfFile:path];
    NSMutableArray *emotionArray = [NSMutableArray array];
    if (!_emotionArray) {
        for (NSDictionary *dict in array) {
            XHEmotion *emotion = [XHEmotion emotionWithDic:dict];
            [emotionArray addObject:emotion];
        }
        _emotionArray = emotionArray;
    }
    return  _emotionArray;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        
        NSInteger count = self.emotionArray.count%EmotionPageCount==0?self.emotionArray.count/EmotionPageCount:self.emotionArray.count/EmotionPageCount+1;
        NSInteger actualPageCount = EmotionPageCount;
        
        //会用到的view的宽高
        CGFloat viewWidth =self.frame.size.width;
        CGFloat viewHeight = 130;
        
        //往view里面添加一个scrollView
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.pagingEnabled = YES;
        scrollView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
        scrollView.contentSize = CGSizeMake(count*viewWidth, viewHeight);
        
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        pageControl.userInteractionEnabled = NO;
        pageControl.numberOfPages = count;
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        pageControl.pageIndicatorTintColor = [UIColor blueColor];
        pageControl.frame = CGRectMake((viewWidth-100)/2, 130, 100, 20);
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
        for (int i=0; i<count; i++) {
            XHEmotionPageView *emotionPageView = [[XHEmotionPageView alloc]init];
            emotionPageView.frame =CGRectMake(i*viewWidth, 0, viewWidth, viewHeight);
            if (i==count -1) actualPageCount = self.emotionArray.count%EmotionPageCount;
            emotionPageView.emotionArray = [self.emotionArray subarrayWithRange:NSMakeRange(i * EmotionPageCount,actualPageCount)];
            [scrollView addSubview:emotionPageView];
        }
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        self.scrollView.delegate = self;
        
    }
    return self;
}

#pragma mark scrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 1. 获取滚动的x方向的偏移值
    CGFloat offsetX = scrollView.contentOffset.x;
    // 用已经偏移了得值, 加上半页的宽度
    offsetX = offsetX + (scrollView.frame.size.width * 0.5);
    
    // 2. 用x方向的偏移的值除以一张图片的宽度(每一页的宽度)，取商就是当前滚动到了第几页（索引）
    int page = offsetX / scrollView.frame.size.width;
    
    // 3. 将页码设置给UIPageControl
    self.pageControl.currentPage = page;
    
}





@end
