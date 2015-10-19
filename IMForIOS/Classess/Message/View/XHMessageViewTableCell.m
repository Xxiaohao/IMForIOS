//
//  XHMessageViewTableCell.m
//  IMForIOS
//
//  Created by LC on 15/10/15.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHMessageViewTableCell.h"

@implementation XHMessageViewTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



+(instancetype)messageViewCellWithTableView :(UITableView *)tableView{
   static NSString *ID = @"messageView_cell";
   XHMessageViewTableCell *messageViewCell =  [tableView dequeueReusableCellWithIdentifier:ID];
    if (!messageViewCell) {
        messageViewCell = [[[NSBundle mainBundle]loadNibNamed:@"XHMessageViewTableCell" owner:nil options:nil]firstObject];
    }
    return messageViewCell;
}




@end
