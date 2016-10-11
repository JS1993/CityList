//
//  AFCore.m
//  MobileOffice
//
//  Created by jf_jin on 16/7/13.
//  Copyright © 2016年 jf_jin. All rights reserved.
//

#import "AFCore.h"
#import "AFNetworking.h"
@implementation AFCore


//创建可变字典
+ (NSMutableDictionary *)createDic:(NSDictionary *)dic{
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    if (dic) {
        
        parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    
    return parameters;
}

//实现AFN的数据请求
+ (AFHTTPSessionManager *)createManager{
    
    // 1.获取请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.设置请求参数的格式：
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];

    return manager;
}



#pragma mark - post请求
+ (void)postWithURL:(NSString *)url withParameters:(NSDictionary *)parameters success:(void(^)(id response))block{
    
    //  URL
    NSString *urlString =[NSString stringWithFormat:@"%@",url];
    // 请求参数
    NSMutableDictionary *parameter = [AFCore createDic:parameters];
    
    AFHTTPSessionManager *manager = [AFCore createManager];
    
    [manager POST:urlString parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"错误原因：%@",error);
    }];
}









@end
