//
//  TQChoiceCell.m
//  QuestionnaireDemo
//
//  Created by tianqi on 2018/1/10.
//  Copyright © 2018年 com.wiscess. All rights reserved.
//

#import "TQChoiceCell.h"
#import "Masonry.h"
#import "TQQuestionModel.h"


@interface TQChoiceCell()
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *biaohaoLB;
@end

@implementation TQChoiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self setupConstraints];
    }
    return self;
}
- (void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor=[UIColor colorWithRed:247/255.0 green:250/255.0 blue:247/255.0 alpha:1.0];
    
    self.checkBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkBtn setImage:[UIImage imageNamed:@"timu_uncheck"] forState:UIControlStateNormal];
    [self.checkBtn setImage:[UIImage imageNamed:@"timu_checked"] forState:UIControlStateSelected];
    [self.checkBtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.checkBtn];
    
    
    self.biaohaoLB=[[UILabel alloc] init];
    self.biaohaoLB.textColor =[UIColor colorWithRed:75/255.0 green:75/255.0 blue:75/255.0 alpha:1.0];
    self.biaohaoLB.textAlignment = NSTextAlignmentLeft;
    self.biaohaoLB.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.biaohaoLB];
    
    
    self.titleLB = [[UILabel alloc] init];
    self.titleLB.textColor =[UIColor colorWithRed:75/255.0 green:75/255.0 blue:75/255.0 alpha:1.0];
    self.titleLB.textAlignment = NSTextAlignmentLeft;
    self.titleLB.font = [UIFont systemFontOfSize:14];
    self.titleLB.numberOfLines=0;
    [self.contentView addSubview:self.titleLB];
}

- (void)setupConstraints {
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(4);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        
    }];
    [self.biaohaoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.checkBtn.mas_right).with.offset(-2);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.biaohaoLB.mas_trailing).with.offset(0);
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        make.right.lessThanOrEqualTo(self.contentView.mas_right).with.offset(0);
        
    }];
}
-(void)setIndex:(NSInteger)index{
    _index=index;
}
-(void)setModel:(TQQuestionModel *)model{
    _model=model;
    _titleLB.text=model.answer[_index];
    _biaohaoLB.text=[self getBiaoqian:_index];
    _checkBtn.tag=_index;
    
    NSString *userAnswer=model.userAnswer;//1-1@2-1,2@3-2,3
    if (userAnswer && ![userAnswer isEqualToString:@""]) {
        NSArray *userAnswers=[userAnswer componentsSeparatedByString:@","];
        if (userAnswers && userAnswers.count>0) {
            for (NSInteger i=0; i<userAnswers.count; i++) {
                NSInteger selectIndex=[userAnswers[i] integerValue];
                if (selectIndex==(_index+1)) {
                    [_checkBtn setSelected:YES];
                    break;
                }else{
                    [_checkBtn setSelected:NO];
                }
            }
        }
    }else{
        [_checkBtn setSelected:NO];
    }
    
}
-(NSString *)getBiaoqian:(NSInteger)i{
    NSString *result=@"";
    switch (i) {
        case 0:
            result= @"A.";
            break;
        case 1:
            result= @"B.";
            break;
        case 2:
            result= @"C.";
            break;
            
        case 3:
            result= @"D.";
            break;
        case 4:
            result= @"E.";
            break;
        case 5:
            result= @"F.";
            break;
        case 6:
            result= @"G.";
            break;
        default:
            break;
    }
    return result;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)checkAction:(id)sender{
    UIButton *btn=(UIButton *)sender;
    NSString *userAnswer=_model.userAnswer;
    NSMutableArray *userAnswers;
    if (userAnswer && ![userAnswer isEqualToString:@""]) {
        userAnswers=[[userAnswer componentsSeparatedByString:@","] mutableCopy];
    }else{
        userAnswers=[[NSMutableArray alloc] init];
    }
    
    if (_model.questionType==TQQuestionMultipleChoice) {
        if (btn.selected) {
            [btn setSelected:NO];
            if ([userAnswers containsObject:[NSString stringWithFormat:@"%ld",(long)(_index+1)]]) {
                [userAnswers removeObject:[NSString stringWithFormat:@"%ld",(long)(_index+1)]];
            }
            
        }else{
            [btn setSelected:YES];
            if (![userAnswers containsObject:[NSString stringWithFormat:@"%ld",(long)(_index+1)]]) {
                [userAnswers addObject:[NSString stringWithFormat:@"%ld",(long)(_index+1)]];
            }
        }
        _model.userAnswer=[userAnswers componentsJoinedByString:@","];
    }else if (_model.questionType==TQQuestionSingleChoice){
        BOOL btnSelected=btn.selected;
        for(UIView *containerSubview in self.superview.subviews)
        {
            for(UIView *subview in containerSubview.subviews)
            {
                for(UIView *subSubView in  subview.subviews){
                    if([subSubView isKindOfClass:[UIButton class]])
                    {
                        UIButton *tempBtn = (UIButton*)subSubView;
                        [tempBtn setSelected:NO];
                        
                    }
                }
                
            }
        }
        if (btnSelected) {
            [btn setSelected:NO];
            _model.userAnswer=@"";
        }else{
            [btn setSelected:YES];
            _model.userAnswer=[NSString stringWithFormat:@"%ld",(long)(_index+1)];
        }
        
    }
    if ([_delegate respondsToSelector:@selector(UserAnswerChanged:atIndex:)]) {
        [_delegate UserAnswerChanged:_model.userAnswer atIndex:_index];
    }
    
}
@end
