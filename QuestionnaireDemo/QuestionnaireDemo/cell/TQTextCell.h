//
//  TQTextCell.h
//  QuestionnaireDemo
//
//  Created by tianqi on 2018/1/10.
//  Copyright © 2018年 com.wiscess. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TQQuestionModel;

@protocol TQTextDelegate <NSObject>

@optional
-(void)UserAnswerChanged:(NSString *)text atIndex:(NSInteger)ind;
@end

@interface TQTextCell : UITableViewCell<UITextViewDelegate>
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong) TQQuestionModel *model;
@property(nonatomic,assign) NSInteger index;
@property(nonatomic,weak)id<TQTextDelegate>delegate;

@end
