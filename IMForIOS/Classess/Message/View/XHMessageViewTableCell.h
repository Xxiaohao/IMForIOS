//
//  XHMessageViewTableCell.h
//  IMForIOS
//
//  Created by LC on 15/10/15.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHMessageViewTableCell : UITableViewCell

@property (nonatomic,strong)NSArray *messageArrays;

+(instancetype)messageViewCellWithTableView:(UITableView *)tableview;

@end
