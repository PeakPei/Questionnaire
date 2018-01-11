//
//  TQTextCell.m
//  QuestionnaireDemo
//
//  Created by tianqi on 2018/1/10.
//  Copyright © 2018年 com.wiscess. All rights reserved.
//

#import "TQTextCell.h"
#import "Masonry.h"
#import "TQQuestionModel.h"

@implementation TQTextCell

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
    self.contentView.backgroundColor=[UIColor colorWithRed:247/255.0 green:250/255.0 blue:255/255.0 alpha:1.0];
    
    self.textView=[[UITextView alloc] init];
    self.textView.backgroundColor=[UIColor whiteColor];
    self.textView.layer.borderColor=[UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:1.0].CGColor;
    self.textView.layer.borderWidth=1;
    self.textView.delegate=self;
    [self.contentView addSubview:self.textView];
    
}

- (void)setupConstraints {
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-30);
        
    }];
    
}
-(void)setIndex:(NSInteger)index{
    _index=index;
}
-(void)setModel:(TQQuestionModel *)model{
    _model=model;
    NSString *userAnswer=model.userAnswer;
    _textView.text=userAnswer;
    [self setDefaultText];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
    [self endEditing:YES];
}

#pragma mark UITextView delegate

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [_textView resignFirstResponder];
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if([_textView.text isEqualToString:NSLocalizedString(@"请填写...",nil)])
        _textView.text = @"";
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([_delegate respondsToSelector:@selector(UserAnswerChanged:atIndex:)]) {
        [_delegate UserAnswerChanged:_textView.text atIndex:_index];
    }
    [self setDefaultText];
    
}
-(void)setDefaultText
{
    if(!_textView.text || [_textView.text length] == 0)
    {
        _textView.text = NSLocalizedString(@"请填写...",nil);
    }
}

@end
