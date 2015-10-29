//
//  XHDataBaseManager.m
//  IMForIOS
//
//  Created by LC on 15/10/28.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHDataBaseManager.h"
#import "XHChatBean.h"
#import "XHUserInfo.h"

//@end

@implementation XHDataBaseManager

singleton_implementation(XHDataBaseManager)

-(id)init{
    if (self=[super init]) {
        _db = [self createDataBase];
    }
    return self;
}

//创建数据库、表
-(id)createDataBase{
    //获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbName = [doc stringByAppendingPathComponent:@"im.sqlite"];
    
    //创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbName];
    
    //打开数据库
    if ([db open]) {
        BOOL result = [db executeUpdate:@"create table if not exists msgs(id integer primary key,userid text,senderID text ,receiverID text ,time date , msg text,indexs text,flag text);"];//通过index可以对msg进行切片，flag标记该条消息是否已读
        if (result) {
            XHLog(@"创建表msgs");
        }else{
            XHLog(@"未创建表");
        }
    }
    return db;
}

/**将消息放入本地数据库中的msgs表中 */
-(NSInteger)insertMessageWithDict:(NSDictionary *)dict andFlag:(NSString *)flag{
    XHChatBean *chatBean = [XHChatBean objectWithKeyValues:dict];
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    //时间转换的时候将时区设置为utc，这样就不会有8小时的时差
    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *time = [format dateFromString:[chatBean.time substringToIndex:19]];
    
    BOOL result=0;
    if ([self.db open]) {
        result =  [self.db executeUpdate:@"insert into msgs values(?,?,?,?,?,?,?,?)",nil,[XHUserInfo sharedXHUserInfo].userID,chatBean.senderID,chatBean.receiverID,time,chatBean.msg,chatBean.indexs,flag];
    }
    [self.db close];
    return result;
}



/**将msgs表中已读消息的flag改成read */
-(NSInteger)updateMessageWithSender:(NSString *)senderID{
    BOOL result=0;
    if ([[XHDataBaseManager sharedXHDataBaseManager].db open]) {
        result =  [[XHDataBaseManager sharedXHDataBaseManager].db executeUpdate:@"update msgs set flag = 'read' where userid = ? and senderID = ? ",[XHUserInfo sharedXHUserInfo].userID,senderID];
    }
    [[XHDataBaseManager sharedXHDataBaseManager].db close];
    return result;
}

/**读取msgs表中的消息数据 */
-(NSMutableArray *)readMessageWithSender:(NSString *)senderID{
    NSMutableArray *historyMsgsArrar = [NSMutableArray array];
    if ([[XHDataBaseManager sharedXHDataBaseManager].db open]) {
        FMResultSet *rs = [[XHDataBaseManager sharedXHDataBaseManager].db executeQuery:@"select * from msgs where userid = ? and senderID = ? ",[XHUserInfo sharedXHUserInfo].userID,senderID];
        //        dict =[rs columnNameToIndexMap];
        while ([rs next]) {
            NSDictionary *dict = [rs resultDictionary];
            [historyMsgsArrar addObject:dict];
            XHLog(@"msgs dict is %@",dict);
        }
        [rs close];
    }
    [[XHDataBaseManager sharedXHDataBaseManager].db close];
    return historyMsgsArrar;
}


@end
