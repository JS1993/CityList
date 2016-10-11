//
//  AFCore.h
//  MobileOffice
//
//  Created by jf_jin on 16/7/13.
//  Copyright © 2016年 jf_jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFCore : NSObject


#pragma mark - post请求
+ (void)postWithURL:(NSString *)url withParameters:(NSDictionary *)parameters success:(void(^)(id response))block;


@end
