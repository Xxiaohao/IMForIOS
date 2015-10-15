//
//  XHGroupModel.h
//  IMForIOS
//
//  Created by LC on 15/10/12.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHGroupModel : NSObject

@property (nonatomic,assign)int groupID;//讨论组id
@property (nonatomic,copy)NSString *createTime;//创建日期
@property (nonatomic,copy)NSString *creatorID;//创建者ID
@property (nonatomic,copy)NSString *groupName;//讨论组名称
@property (nonatomic,strong)NSArray *groupMembers;//讨论组成员ID
@property (nonatomic,strong)NSArray *oldGroupMemberArrayList;//讨论组已有成员
@property (nonatomic,strong)NSArray *addingGroupMemberArrayList;//讨论组新增成员
@property (nonatomic,strong)NSArray *groupMembersDetails;//讨论组成员详细信息

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)groupWithDict:(NSDictionary *)dict;
@end
