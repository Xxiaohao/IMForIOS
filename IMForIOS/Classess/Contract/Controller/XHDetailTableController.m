//
//  XHDetailTableController.m
//  IMForIOS
//
//  Created by 小侠 on 15-10-20.
//  Copyright © 2015年 XH. All rights reserved.
//

#import "XHDetailTableController.h"

@interface XHDetailTableController ()

@end

@implementation XHDetailTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    aButton.frame = CGRectMake(0, 100, 20, 44);
    aButton.titleLabel.text = NSLocalizedString(@"发送消息", null);
    self.tableView.tableFooterView = aButton;
    
    self.tableView.dataSource = self;
    XHLog(@"DetailTablecontroller is ing....");
    
}
-(void)setMyListArray:(NSArray *)myListArray{
    
    _myListArray = myListArray;
}

-(void)setContactModel:(XHContactModel *)contactModel{
    _contactModel=contactModel;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    XHLog(@"row :%ld",[_myListArray count]);
    return [_myListArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID =@"detail_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    if (!cell) {
         cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    cell.textLabel.text=[_myListArray objectAtIndex:indexPath.row];
   
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



@end
