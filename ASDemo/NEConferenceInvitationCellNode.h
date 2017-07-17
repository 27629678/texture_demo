//
//  NEConferenceInvitationCellNode.h
//  ASDemo
//
//  Created by hzyuxiaohua on 2017/7/17.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

typedef NS_ENUM(NSUInteger, NEConferenceInvitationStatus) {
    NEConferenceInvitationStatusUnknown,
    NEConferenceInvitationStatusAccept,
    NEConferenceInvitationStatusPending,
    NEConferenceInvitationStatusRejected,
};

@interface NEConferenceInvitationCellNode : ASCellNode

@property (nonatomic, assign) BOOL shouldDisplayControllerButton;

- (instancetype)initWithDate:(NSString *)date location:(NSString *)location status:(NSUInteger)status;

@end
