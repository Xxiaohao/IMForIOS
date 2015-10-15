//
//  XHGroupTableController.m
//  IMForIOS
//
//  Created by LC on 15/9/18.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHGroupTableController.h"
#import "XHGroupModel.h"

@interface XHGroupTableController ()



@end

@implementation XHGroupTableController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XHGroupModel *groupModel = [[XHGroupModel alloc]initWithDict: self.groupInfos[indexPath.row]];
    static NSString *ID=@"group_cell";
    UITableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:ID ];
    
    if (!groupCell) {
        groupCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    groupCell.textLabel.text = groupModel.groupName;
    
    // Configure the cell...
    
    return groupCell;
}



@end
