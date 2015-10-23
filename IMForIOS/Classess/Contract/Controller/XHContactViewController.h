//
//  XHContactViewController.h
//  IMForIOS
//
//  Created by LC on 15/9/17.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHContactViewController : UIViewController

@property (nonatomic,strong)NSArray *contacts;
@property (nonatomic,strong)NSArray *groupInfos;

-(void)addContactTable;

@end
