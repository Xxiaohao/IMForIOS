//
//  XHContactTableViewCell.m
//  IMForIOS
//
//  Created by LC on 15/9/17.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHContactTableViewCell.h"

@interface XHContactTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *userSigner;
@end

@implementation XHContactTableViewCell



-(void)setContactModel:(XHContactModel *)contactModel{
//    self.headImage
    _contactModel=contactModel;
//    NSLog(@"contactModel");
    self.nickName.text=contactModel.userName;
    self.userSigner.text = contactModel.userSignature;
    self.headImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%03d",contactModel.upheadspe]];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
