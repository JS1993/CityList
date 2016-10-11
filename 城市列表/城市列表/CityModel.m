//
//  CityModel.m
//  城市列表
//
//  Created by  江苏 on 2016/10/11.
//  Copyright © 2016年 jf_jin. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel
    //更换模型属性名
+ (NSDictionary *)replacedKeyFromPropertyName{
        return @{
                 @"ID" : @"id"
                 };
}

    
@end
