//
//  ViewController.m
//  城市列表
//
//  Created by jf_jin on 16/10/9.
//  Copyright © 2016年 jf_jin. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+Log.h"
#import "NSDictionary+Log.h"
#import "AFNetworking.h"
#import "AFCore.h"
#import "CityModel.h"

#define Gray_COLOR [UIColor colorWithRed:245.f/255.f green:246.f/255.f blue:247.f/255.f alpha:1]//默认灰

@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIView *bgview;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIPickerView *pickerview;
@property (nonatomic, strong) NSDictionary *pickerdic;
/** 省 **/
@property (nonatomic, strong) NSArray *pickerAry;
/** 市 **/
@property (strong,nonatomic)NSArray *cityList;
/** 区 **/
@property (strong,nonatomic)NSArray *areaList;
/** 第一级选中的下标 **/
@property (assign, nonatomic)NSInteger selectOneRow;
/** 第二级选中的下标 **/
@property (assign, nonatomic)NSInteger selectTwoRow;
/** 第三级选中的下标 **/
@property (assign, nonatomic)NSInteger selectThreeRow;

@property(nonatomic,strong)NSMutableArray* js_areas;
@property(nonatomic,strong)NSMutableArray* js_citys;//市
@property(nonatomic,strong)NSMutableArray* js_district;//区
@property(nonatomic,strong)NSMutableArray* js_street;//街道

@end

@implementation ViewController
    

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.js_areas = [NSMutableArray array];
    self.js_street=[NSMutableArray array];
    self.js_citys = [NSMutableArray array];
    self.js_district=[NSMutableArray array];
    [self loadData];
    
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, 30)];
    self.titleLab.text = @"请选择";
    self.titleLab.backgroundColor = [UIColor grayColor];
    self.titleLab.userInteractionEnabled = YES;
    self.titleLab.textColor = [UIColor redColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabTap)];
    [self.titleLab addGestureRecognizer:tap];
    [self.view addSubview:self.titleLab];
    
    self.bgview = [[UIView alloc]init];
    self.bgview.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
    self.bgview.backgroundColor = Gray_COLOR;
    [self.view addSubview:self.bgview];
    
    UIView *btnView = [[UIView alloc]init];
    btnView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    btnView.backgroundColor = [UIColor lightGrayColor];
    [self.bgview addSubview:btnView];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10, 5, 60, 30);
    [sureBtn setTitle:@"取消" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtn) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:sureBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(self.view.frame.size.width - 70, 5, 60, 30);
    [cancelBtn setTitle:@"确定" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:cancelBtn];
    
    self.pickerview = [[UIPickerView alloc]init];
    self.pickerview.frame = CGRectMake(0, 40, self.view.frame.size.width, 260);
    self.pickerview.delegate = self;
    self.pickerview.dataSource = self;
    [self.bgview addSubview:self.pickerview];
    
    self.pickerAry = [NSArray array];
    [self Dataparsing];
    [self getAreaDate:0];
    [self getCitydate:0];// 默认显示数据
}
    
- (void)Dataparsing{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"city" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSDictionary *provinceLise = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    self.pickerdic = provinceLise;
    self.pickerAry = [NSArray array];
    self.pickerAry = self.pickerdic[@"citylist"];
    
/**
 *    服务器接口    ************************************
 */
    [AFCore postWithURL:@"" withParameters:nil success:^(id response) {
    
        NSLog(@"市   区   街道:  %@",response);
    }];
    
}
//取到市
- (void)getCitydate:(NSInteger)row{
    
    NSMutableArray *cityList = [[NSMutableArray alloc] init];
    for (NSArray *cityArr in self.pickerAry[row][@"c"]) {
        [cityList addObject:cityArr];
    }
    self.cityList = cityList;
//    NSLog(@"self.cityList======%@",self.cityList);
}
- (void)getAreaDate:(NSInteger)row{
    
    NSArray *ary;
    NSMutableArray *areaList = [[NSMutableArray alloc] init];
    //有特区或者直辖市没有第三级  把存放三级数据的数组置空或者删除
    if (self.cityList[row][@"a"] == nil) {
        
    }else{
        ary = self.cityList[row][@"a"];
    }
    if (ary.count == 0) {
        self.areaList = nil;
        return;
    }else{
        for (NSArray *cityDict in self.cityList[row][@"a"]) {
            [areaList addObject:cityDict];
        }
        self.areaList = areaList;
    }
    
}
- (void)titleLabTap{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.bgview.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
    }];
    
}

- (void)sureBtn{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.bgview.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
    } completion:^(BOOL finished) {
    }];
}

- (void)cancelBtn{
    [UIView animateWithDuration:0.5 animations:^{
        self.bgview.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
    } completion:^(BOOL finished) {
        //        [self.bgview removeFromSuperview];
    }];
    
}

-(void)loadData{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"test(2)" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSDictionary *provinceLise = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    self.js_areas = [CityModel mj_objectArrayWithKeyValuesArray:provinceLise[@"citylist"]];
    
    for (CityModel* model in self.js_areas) {
        //两为对应省，四位对应市，六位对应区,先将省市区分开来
        model.childAreas = [NSMutableArray array];//顺便初始化属性数组
        if (model.ID.length==4) {
            [self.js_citys addObject:model];
        }else if (model.ID.length==6){
            [self.js_district addObject:model];
        }else {
            [self.js_street addObject:model];
        }
    }
    
    //双重遍历，在街道数组中寻找对应的市 model，并且将街道元素添加到区元素的子数组中
    for (CityModel* disModel in self.js_district) {
        for (CityModel* streetModel in self.js_street) {
            if ([disModel.ID isEqualToString:streetModel.parentId]) {
                [disModel.childAreas addObject:streetModel];
            }
        }
    }
    
    //双重遍历，在区数组中寻找对应的市 model，并且将区元素添加到市元素的子数组中
    for (CityModel* cityModel in self.js_citys) {
        for (CityModel* disModel in self.js_district) {
            if ([cityModel.ID isEqualToString:disModel.parentId]) {
                [cityModel.childAreas addObject:disModel];
            }
        }
    }
    
}
    
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
        return 3;
}
    
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return self.js_citys.count;
    }else if (component==1){
        return [self.js_citys[self.selectOneRow] childAreas].count;
    }else{
        return [[self.js_citys[self.selectOneRow] childAreas][self.selectTwoRow] childAreas].count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        return [self.js_citys[row] name];
    }else if (component==1){
        return [[self.js_citys[self.selectOneRow] childAreas][row] name];
    }else{
        return [[[self.js_citys[self.selectOneRow] childAreas][self.selectTwoRow] childAreas][row] name];
    }
}
    
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    static NSInteger oneRow = 0;
    static NSInteger tweRow = 0;
    static NSInteger threeRow = 0;
    if (component == 0) {
        self.selectOneRow = row;
        [self getCitydate:row];
        //重新加载 第二列
        [pickerView reloadComponent:1];
        //默认选中第一列中的第一个数据
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [self getAreaDate:0];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        oneRow = row;
        tweRow = 0;
        threeRow = 0;
    }
    
    if (component == 1){
        
        self.selectTwoRow = row;
        [self getAreaDate:row];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        tweRow = row;
        threeRow = 0;
    }
    
    if (component == 2){
        
        self.selectThreeRow = row;
        threeRow = row;
    }
}




@end
