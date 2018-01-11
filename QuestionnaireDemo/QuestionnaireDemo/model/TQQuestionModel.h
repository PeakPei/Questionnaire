//
//  TQQuestionModel.h
//  QuestionnaireDemo
//
//  Created by tianqi on 2018/1/10.
//  Copyright © 2018年 com.wiscess. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    TQQuestionSingleChoice,//单选题
    TQQuestionMultipleChoice,//多选题
    TQQuestionOpenQuestion,//主观题
} TQQuestionType;

@interface TQQuestionModel : NSObject
@property(nonatomic,strong)NSString *questionDesc;
@property(nonatomic,strong)NSString *questionId;
@property(nonatomic,strong)NSArray *answer;
@property(nonatomic,strong)NSString *userAnswer;
@property(nonatomic,strong)NSString *wjId;
@property(assign)TQQuestionType questionType;
@end
