//
//  YXLDetail.h
//  IMForIOS
//
//  Created by 小侠 on 15-10-29.
//  Copyright © 2015年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHContactModel.h"
#import "Singleton.h"

@protocol YXLDetailDelegate <NSObject>

-(void)pushToMessageListViewControllerWithContact:(XHContactModel *)contact;

@end

@interface YXLDetail : UIViewController
singleton_interface(YXLDetail)

@property (nonatomic,strong)  XHContactModel *contactModel;
@property (nonatomic,assign)  id<YXLDetailDelegate> detailDelegate;

-(void)setButtonWithNSString:(NSString *)string;



@end
