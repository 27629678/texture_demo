//
//  NEConferenceInvitationCellNode.m
//  ASDemo
//
//  Created by hzyuxiaohua on 2017/7/17.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

#import "NEConferenceInvitationCellNode.h"

#define kCI_AcceptBtnTitle          NSLocalizedString(@"授受", @"")
#define kCI_PendingBtnTitle         NSLocalizedString(@"暂定", @"")
#define kCI_RejectedBtnTitle        NSLocalizedString(@"拒绝", @"")

#define kCI_AcceptDescription       NSLocalizedString(@"你已接受本次会议邀请", @"")
#define kCI_PendingDescription      NSLocalizedString(@"你已暂时接受本次会议邀请", @"")
#define kCI_RejectedDescription     NSLocalizedString(@"你已谢绝本次会议邀请", @"")

@interface NEConferenceInvitationCellNode ()

@property (nonatomic, strong) ASTextNode *date;
@property (nonatomic, strong) ASImageNode *date_icon;
@property (nonatomic, strong) ASTextNode *location;
@property (nonatomic, strong) ASImageNode *location_icon;
@property (nonatomic, strong) ASButtonNode *accept;
@property (nonatomic, strong) ASButtonNode *pending;
@property (nonatomic, strong) ASButtonNode *rejected;
@property (nonatomic, strong) ASImageNode *background_image;
@property (nonatomic, strong) ASImageNode *vertical_separator1;
@property (nonatomic, strong) ASImageNode *vertical_separator2;
@property (nonatomic, strong) ASImageNode *horizontal_separator;
@property (nonatomic, assign) NEConferenceInvitationStatus status;

// status
@property (nonatomic, strong) ASImageNode *status_icon;
@property (nonatomic, strong) ASTextNode *status_description;

@end

@implementation NEConferenceInvitationCellNode

- (instancetype)initWithDate:(NSString *)date location:(NSString *)location status:(NSUInteger)status
{
    if (self = [super init]) {
        self.status = status;
        self.shouldDisplayControllerButton = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.date.attributedText = [self attributedString:date];
        self.location.attributedText = [self attributedString:location];
    }
    
    return self;
}

#pragma mark - override

- (void)didLoad
{
    [super didLoad];
    
    // background
    [self addSubnode:self.background_image];
    
    // date
    [self addSubnode:self.date_icon];
    [self addSubnode:self.date];
    
    // location
    [self addSubnode:self.location_icon];
    [self addSubnode:self.location];
    
    if (!self.shouldDisplayControllerButton) {
        return;
    }
    
    // horizontal separator
    [self addSubnode:self.horizontal_separator];
    [self addSubnodeWithStatus:self.status];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    NSMutableArray *children = [NSMutableArray array];
    ASStackLayoutSpec *container = [ASStackLayoutSpec verticalStackLayoutSpec];
    
    // background
    ASInsetLayoutSpec *background_spec =
    [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(5, 5, 5, 5)
                                           child:self.background_image];
    
    ASInsetLayoutSpec *container_spec =
    [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(8, 8, 8, 8)
                                           child:container];
    ASBackgroundLayoutSpec *spec = [[ASBackgroundLayoutSpec alloc] init];
    spec.child = container_spec;
    spec.background = background_spec;
    
    // date
    self.date.style.maxWidth = ASDimensionMake(constrainedSize.max.width - 60);
    ASStackLayoutSpec *date_icon_ver_spec = [ASStackLayoutSpec verticalStackLayoutSpec];
    date_icon_ver_spec.child = self.date_icon;
    
    ASInsetLayoutSpec *date_icon_spec =
    [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15, 10, 10, 0)
                                           child:date_icon_ver_spec];
    ASInsetLayoutSpec *date_text_spec =
    [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10)
                                           child:self.date];
    
    ASStackLayoutSpec *date_spec = [ASStackLayoutSpec horizontalStackLayoutSpec];
    date_spec.children = @[date_icon_spec, date_text_spec];
    [children addObject:date_spec];
    
    // location
    self.location.style.maxWidth = ASDimensionMake(constrainedSize.max.width - 60);
    ASInsetLayoutSpec *location_icon_spec =
    [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15, 10, 10, 0)
                                           child:self.location_icon];
    ASStackLayoutSpec *ver = [ASStackLayoutSpec verticalStackLayoutSpec];
    ver.children =  @[location_icon_spec];
    ASInsetLayoutSpec *location_text_spec =
    [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10)
                                           child:self.location];
    
    ASStackLayoutSpec *location_spec = [ASStackLayoutSpec horizontalStackLayoutSpec];
    location_spec.children = @[ver, location_text_spec];
    [children addObject:location_spec];
    
    if (!_shouldDisplayControllerButton) {
        container.children = children;
        
        return spec;
    }
    
    // horizontal separator
    ASInsetLayoutSpec *h_separator_spec =
    [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(5, 2, 5, 2)
                                           child:self.horizontal_separator];
    [children addObject:h_separator_spec];
    
    switch (self.status) {
        case NEConferenceInvitationStatusUnknown: {
            // buttons
            ASStackLayoutSpec *button_spec = [ASStackLayoutSpec horizontalStackLayoutSpec];
            button_spec.children = @[ self.accept,
                                      self.vertical_separator1,
                                      self.pending,
                                      self.vertical_separator2,
                                      self.rejected];
            button_spec.justifyContent = ASStackLayoutJustifyContentSpaceAround;
            
            
            ASInsetLayoutSpec *btn_inset_spec =
            [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(5, 2, 5, 2) child:button_spec];
            [children addObject:btn_inset_spec];
        }
            
            break;
            
        default: {
            ASInsetLayoutSpec *status_icon_inset_spec =
            [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(3, 0, 0, 0) child:self.status_icon];
            ASCenterLayoutSpec *status_icon_center_spec =
            [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY
                                                       sizingOptions:ASCenterLayoutSpecSizingOptionDefault
                                                               child:status_icon_inset_spec];
            ASStackLayoutSpec *status_icon_stack_spec = [ASStackLayoutSpec verticalStackLayoutSpec];
            status_icon_stack_spec.child = status_icon_center_spec;
            
            ASStackLayoutSpec *inner_stack_spec = [ASStackLayoutSpec horizontalStackLayoutSpec];
            inner_stack_spec.children = @[status_icon_stack_spec, self.status_description];
            inner_stack_spec.spacing = 5;
            
            ASCenterLayoutSpec *status_sepc =
            [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY
                                                       sizingOptions:ASCenterLayoutSpecSizingOptionDefault
                                                               child:inner_stack_spec];
            [children addObject:status_sepc];
        }
            
            break;
    }
    
    container.children = children;
    
    return spec;
}

#pragma mark - getter & setter

- (ASTextNode *)date
{
    if (!_date) {
        ASTextNode *node = [[ASTextNode alloc] init];
        
        _date = node;
    }
    
    return _date;
}

- (ASTextNode *)location
{
    if (!_location) {
        ASTextNode *node = [[ASTextNode alloc] init];
        
        _location = node;
    }
    
    return _location;
}

- (ASImageNode *)background_image
{
    if (!_background_image) {
        ASImageNode *node = [[ASImageNode alloc] init];
        UIImage *image = [UIImage imageNamed:@"background"];
        node.image = [image stretchableImageWithLeftCapWidth:15 topCapHeight:15];
        
        _background_image = node;
    }
    
    return _background_image;
}

- (ASImageNode *)date_icon
{
    if (!_date_icon) {
        ASImageNode *node = [[ASImageNode alloc] init];
        node.image = [UIImage imageNamed:@"date"];
        
        _date_icon = node;
    }
    
    return _date_icon;
}

- (ASImageNode *)location_icon
{
    if (!_location_icon) {
        ASImageNode *node = [[ASImageNode alloc] init];
        node.image = [UIImage imageNamed:@"location"];
        
        _location_icon = node;
    }
    
    return _location_icon;
}

- (ASImageNode *)horizontal_separator
{
    if (!_horizontal_separator) {
        ASImageNode *node = [[ASImageNode alloc] init];
        node.image = [UIImage imageNamed:@"h_line"];
        
        _horizontal_separator = node;
    }
    
    return _horizontal_separator;
}

- (ASImageNode *)vertical_separator1
{
    if (!_vertical_separator1) {
        ASImageNode *node = [[ASImageNode alloc] init];
        node.image = [UIImage imageNamed:@"v_line"];
        
        _vertical_separator1 = node;
    }
    
    return _vertical_separator1;
}

- (ASImageNode *)vertical_separator2
{
    if (!_vertical_separator2) {
        ASImageNode *node = [[ASImageNode alloc] init];
        node.image = [UIImage imageNamed:@"v_line"];
        
        _vertical_separator2 = node;
    }
    
    return _vertical_separator2;
}

- (ASButtonNode *)accept
{
    if (!_accept) {
        ASButtonNode *node = [[ASButtonNode alloc] init];
        node.contentSpacing = 5;
        [node setImage:[UIImage imageNamed:@"accept"] forState:UIControlStateNormal];
        [node setImage:[UIImage imageNamed:@"accept"] forState:UIControlStateHighlighted];
        [node setTitle:kCI_AcceptBtnTitle withFont:nil withColor:nil forState:UIControlStateNormal];
        [node setTitle:kCI_AcceptBtnTitle withFont:nil withColor:nil forState:UIControlStateHighlighted];
        [node addTarget:self action:@selector(doAcceptAction) forControlEvents:ASControlNodeEventTouchUpInside];
        
        _accept = node;
    }
    
    return _accept;
}

- (ASButtonNode *)pending
{
    if (!_pending) {
        ASButtonNode *node = [[ASButtonNode alloc] init];
        node.contentSpacing = 5;
        [node setImage:[UIImage imageNamed:@"pending"] forState:UIControlStateNormal];
        [node setImage:[UIImage imageNamed:@"pending"] forState:UIControlStateHighlighted];
        [node setTitle:kCI_PendingBtnTitle withFont:nil withColor:nil forState:UIControlStateNormal];
        [node setTitle:kCI_PendingBtnTitle withFont:nil withColor:nil forState:UIControlStateHighlighted];
        [node addTarget:self action:@selector(doPendingAction) forControlEvents:ASControlNodeEventTouchUpInside];
        
        _pending = node;
    }
    
    return _pending;
}

- (ASButtonNode *)rejected
{
    if (!_rejected) {
        ASButtonNode *node = [[ASButtonNode alloc] init];
        node.contentSpacing = 5;
        [node setImage:[UIImage imageNamed:@"rejected"] forState:UIControlStateNormal];
        [node setImage:[UIImage imageNamed:@"rejected"] forState:UIControlStateHighlighted];
        [node setTitle:kCI_RejectedBtnTitle withFont:nil withColor:nil forState:UIControlStateNormal];
        [node setTitle:kCI_RejectedBtnTitle withFont:nil withColor:nil forState:UIControlStateHighlighted];
        [node addTarget:self action:@selector(doRejectedAction) forControlEvents:ASControlNodeEventTouchUpInside];
        
        _rejected = node;
    }
    
    return _rejected;
}

- (ASImageNode *)status_icon
{
    if (!_status_icon) {
        _status_icon = [[ASImageNode alloc] init];
    }
    
    return _status_icon;
}

- (ASTextNode *)status_description
{
    if (!_status_description) {
        _status_description = [[ASTextNode alloc] init];
    }
    
    return _status_description;
}

#pragma mark - private

- (NSAttributedString *)attributedString:(NSString *)string
{
    static NSDictionary *__attr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        UIFont *font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
        __attr = @{ NSFontAttributeName: font, NSParagraphStyleAttributeName: style };
    });
    
    return [[NSAttributedString alloc] initWithString:string attributes:__attr];
}

- (void)addSubnodeWithStatus:(NEConferenceInvitationStatus)status
{
    if (!self.shouldDisplayControllerButton) {
        return;
    }
    
    [self.accept removeFromSupernode];
    [self.pending removeFromSupernode];
    [self.rejected removeFromSupernode];
    [self.vertical_separator1 removeFromSupernode];
    [self.vertical_separator2 removeFromSupernode];
    
    [self.status_icon removeFromSupernode];
    [self.status_description removeFromSupernode];
    
    switch (status) {
        case NEConferenceInvitationStatusUnknown:
            // vertical separators
            [self addSubnode:self.vertical_separator1];
            [self addSubnode:self.vertical_separator2];
            
            // buttons
            [self addSubnode:self.accept];
            [self addSubnode:self.pending];
            [self addSubnode:self.rejected];
            
            return;
            
        case NEConferenceInvitationStatusAccept:
            self.status_icon.image = [UIImage imageNamed:@"accept"];
            self.status_description.attributedText = [self attributedString:kCI_AcceptDescription];
            break;
            
        case NEConferenceInvitationStatusPending:
            self.status_icon.image = [UIImage imageNamed:@"pending"];
            self.status_description.attributedText = [self attributedString:kCI_PendingDescription];
            break;
            
        case NEConferenceInvitationStatusRejected:
            self.status_icon.image = [UIImage imageNamed:@"rejected"];
            self.status_description.attributedText = [self attributedString:kCI_RejectedDescription];
            break;
    }
    
    [self addSubnode:self.status_icon];
    [self addSubnode:self.status_description];
}

- (void)doAcceptAction
{
    self.status = NEConferenceInvitationStatusAccept;
    [self addSubnodeWithStatus:NEConferenceInvitationStatusAccept];
    [self layoutIfNeeded];
}

- (void)doPendingAction
{
    self.status = NEConferenceInvitationStatusPending;
    [self addSubnodeWithStatus:NEConferenceInvitationStatusPending];
    [self layoutIfNeeded];
}

- (void)doRejectedAction
{
    self.status = NEConferenceInvitationStatusRejected;
    [self addSubnodeWithStatus:NEConferenceInvitationStatusRejected];
    [self layoutIfNeeded];
}

@end
