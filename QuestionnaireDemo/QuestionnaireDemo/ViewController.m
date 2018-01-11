//
//  ViewController.m
//  QuestionnaireDemo
//
//  Created by tianqi on 2018/1/10.
//  Copyright © 2018年 com.wiscess. All rights reserved.
//

#import "ViewController.h"
#import "TQQuestionModel.h"
#import "TQChoiceCell.h"
#import "TQTextCell.h"
#import "UIView+XBExtension.h"
#import "UIView+LSCore.h"
#import "UIView+LXShadowPath.h"
#import "SVProgressHUD.h"



#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

NSString * const kTQChoiceCell  = @"TQChoiceCell";
NSString * const kTQTextCell  = @"TQTextCell";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,TQChoiceDelegate,TQTextDelegate>{
    NSMutableArray *Questions;
}
@property(nonatomic,strong)UIView *tableBackView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *headView;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIButton *preButton;
@property(nonatomic,strong)UIButton *nexButtom;
@property(nonatomic,strong)UILabel *questionLB;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)TQQuestionModel *currentModel;
@property(nonatomic,strong)NSArray *tiMuArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self.view addSubview:self.tableBackView];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.bottomView];
    [self changeData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    Questions=[NSMutableArray new];
    TQQuestionModel *model1=[TQQuestionModel new];
    model1.questionDesc=@"你多大了？";
    model1.questionId=@"7";
    model1.wjId=@"3";
    model1.questionType=TQQuestionSingleChoice;
    model1.answer=@[@"未成年",@"青年",@"老年"];
    [Questions addObject:model1];
    
    TQQuestionModel *model2=[TQQuestionModel new];
    model2.questionDesc=@"你的身高多少?";
    model2.questionId=@"8";
    model2.wjId=@"3";
    model2.questionType=TQQuestionSingleChoice;
    model2.answer=@[@"低",@"中",@"高"];
    [Questions addObject:model2];
    
    TQQuestionModel *model3=[TQQuestionModel new];
    model3.questionDesc=@"你对刘XX评价如何?";
    model3.questionId=@"9";
    model3.wjId=@"3";
    model3.questionType=TQQuestionOpenQuestion;
    [Questions addObject:model3];
    
    TQQuestionModel *model4=[TQQuestionModel new];
    model4.questionDesc=@"你每个月开销主要是？";
    model4.questionId=@"10";
    model4.wjId=@"3";
    model4.questionType=TQQuestionMultipleChoice;
    model4.answer=@[@"公交",@"网购",@"餐饮",@"旅游"];
    [Questions addObject:model4];
    
}

-(void) changeData{
    
    if (self.currentIndex==Questions.count) {
        [self uploadResult];
        return;
    }
    if (self.currentIndex==0) {
        self.preButton.hidden=YES;
    }else{
        self.preButton.hidden=NO;
    }
    if (self.currentIndex>=Questions.count-1) {
        [self.nexButtom setTitle:@"提交" forState:UIControlStateNormal];
    }else{
        [self.nexButtom setTitle:@"下一题" forState:UIControlStateNormal];
    }
    self.headView.text=[NSString stringWithFormat:@"第%ld题",(long)(self.currentIndex+1)];
    self.currentModel =Questions[self.currentIndex];
    self.tiMuArray= self.currentModel.answer;
    [self.tableView reloadData];
    
    
    
}
-(UIView *)tableBackView{
    if (!_tableBackView) {
        _tableBackView=[[UIView alloc] initWithFrame:CGRectMake(20, 121, screen_width-40, 240)];
        [_tableBackView LX_SetShadowPathWith:[UIColor colorWithRed:221/255.0 green:234/255.0 blue:239/255.0 alpha:1.0] shadowOpacity:0.8 shadowRadius:4 shadowSide:LXShadowPathNoTop shadowPathWidth:10];
        [_tableBackView addSubview:self.tableView];
    }
    return _tableBackView;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width-40, 240) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor=[UIColor colorWithRed:247/255.0 green:250/255.0 blue:247/255.0 alpha:1.0];
        [_tableView registerClass:[TQChoiceCell class] forCellReuseIdentifier:kTQChoiceCell];
        [_tableView registerClass:[TQTextCell class] forCellReuseIdentifier:kTQTextCell];
    }
    return _tableView;
}
-(UILabel *)headView{
    if (!_headView) {
        _headView=[[UILabel alloc] initWithFrame:CGRectMake(20, 84, screen_width-40, 37)];
        _headView.backgroundColor=[UIColor colorWithRed:252/255.0 green:205/255.0 blue:80/255.0 alpha:1.0];
        [_headView addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight  withRadii:CGSizeMake(5.0, 5.0)];
        _headView.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _headView.font=[UIFont systemFontOfSize:15];
        _headView.textAlignment=NSTextAlignmentCenter;
        
    }
    return _headView;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, self.tableBackView.bottomY, screen_width, 50)];
        UIButton *preBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        preBtn.frame=CGRectMake(screen_width/2-12-111, 17, 111, 32);
        [preBtn setTitle:@"上一题" forState:UIControlStateNormal];
        [preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [preBtn setBackgroundColor:[UIColor colorWithRed:68/255.0 green:187/255.0 blue:255/255.0 alpha:1.0]];
        preBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        preBtn.layer.masksToBounds=YES;
        preBtn.layer.cornerRadius=5;
        [preBtn addTarget:self action:@selector(preAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:preBtn];
        self.preButton=preBtn;
        
        UIButton *nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        nextBtn.frame=CGRectMake(screen_width/2+12, 17, 111, 32);
        [nextBtn setTitle:@"下一题" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextBtn setBackgroundColor:[UIColor colorWithRed:252/255.0 green:205/255.0 blue:80/255.0 alpha:1.0]];
        nextBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        nextBtn.layer.masksToBounds=YES;
        nextBtn.layer.cornerRadius=5;
        [nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:nextBtn];
        self.nexButtom=nextBtn;
    }
    return _bottomView;
}
-(void)preAction:(id)sender{
    if (self.currentModel && self.currentIndex>=0) {
        [Questions replaceObjectAtIndex:self.currentIndex withObject:self.currentModel];
    }
    self.currentIndex--;
    [self changeData];
    
    
}
-(void)nextAction:(id)sender{
    if(self.currentModel){
        if (!self.currentModel.userAnswer || [self.currentModel.userAnswer isEqualToString:@""]) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showInfoWithStatus:@"请先完成此题"];
            [SVProgressHUD dismissWithDelay:0.5];
            return;
        }
    }
    self.currentIndex++;
    if (self.currentModel && self.currentIndex>=1) {
        [Questions replaceObjectAtIndex:self.currentIndex-1 withObject:self.currentModel];
    }
    [self changeData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TQQuestionModel *model=Questions[self.currentIndex];
    if (model.questionType==TQQuestionSingleChoice ||model.questionType==TQQuestionMultipleChoice) {
        NSArray *answers=model.answer;
        return answers.count;
    }else if(model.questionType==TQQuestionOpenQuestion){
        return 1;
    }
    return 0;
};
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentModel.questionType==TQQuestionOpenQuestion) {
        return 130;
    }else{
        NSString *str=self.tiMuArray[indexPath.row];
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGSize size = [str boundingRectWithSize:CGSizeMake(tableView.width-60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        CGFloat height=size.height;
        return height+20;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentModel.questionType==TQQuestionOpenQuestion) {
        TQTextCell *cell=[tableView dequeueReusableCellWithIdentifier:kTQTextCell];
        cell.index=indexPath.row;
        [cell setModel:self.currentModel];
        cell.delegate=self;
        return cell;
    }else{
        TQChoiceCell * cell = [tableView dequeueReusableCellWithIdentifier:kTQChoiceCell];
        cell.index=indexPath.row;
        [cell setModel:self.currentModel];
        cell.delegate=self;
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width-48, 37.4)];
    headView.backgroundColor=[UIColor colorWithRed:247/255.0 green:250/255.0 blue:247/255.0 alpha:1.0];
    UILabel *questLable=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, screen_width-48, 37)];
    questLable.backgroundColor=[UIColor colorWithRed:247/255.0 green:250/255.0 blue:247/255.0 alpha:1.0];
    questLable.font=[UIFont systemFontOfSize:15];
    questLable.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    questLable.text=self.currentModel.questionDesc;
    [headView addSubview:questLable];
    self.questionLB=questLable;
    return headView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 37.4;
}
-(void)UserAnswerChanged:(NSString *)text atIndex:(NSInteger)ind{
    NSString *userAnswer=text;
    self.currentModel.userAnswer=userAnswer;
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.tableView endEditing:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    [self.tableView endEditing:YES];
    
}
-(void)uploadResult{
    NSMutableArray *chooseArr=[NSMutableArray new];
    NSMutableArray *textArr=[NSMutableArray new];
    for (NSInteger i=0; i<Questions.count; i++) {
        TQQuestionModel *model=Questions[i];
        NSString *userAnswer=model.userAnswer;
        NSString *modelStr=[NSString stringWithFormat:@"%@-%@",model.questionId,userAnswer];
        if (model.questionType==TQQuestionSingleChoice ||model.questionType==TQQuestionMultipleChoice) {
            [chooseArr addObject:modelStr];
        }else if(model.questionType==TQQuestionOpenQuestion){
            [textArr addObject:modelStr];
        }
        
    }
    
    
}
@end
