//
//  XHMessageViewTableCell.h
//  IMForIOS
//
//  Created by LC on 15/10/15.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHContactModel.h"

@interface XHMessageViewTableCell : UITableViewCell

//@property (nonatomic,strong)NSArray *messageArrays;
@property (nonatomic,assign)NSInteger count;
@property (nonatomic,strong)NSDictionary *latestMessageDict;
@property (nonatomic,strong)XHContactModel *contact;

+(instancetype)messageViewCellWithTableView:(UITableView *)tableview;

//给cell设置值
-(void)setValueWithDic:(NSDictionary *)latestMessageDict andContact:(XHContactModel *)contact andCount:(NSInteger)count;

@end
