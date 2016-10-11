//
//  CityModel.h
//  城市列表
//
//  Created by  江苏 on 2016/10/11.
//  Copyright © 2016年 jf_jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

/**
 {"id":"37","parentId":"0","areaCode":"37","name":"山东省"},
 */
@interface CityModel : NSObject
@property(copy,nonatomic)NSString* ID;
@property(copy,nonatomic)NSString* parentId;
@property(copy,nonatomic)NSString* areaCode;
@property(copy,nonatomic)NSString* name;
@property(strong,nonatomic)NSMutableArray* childAreas;
@end
