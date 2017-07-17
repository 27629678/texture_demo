//
//  NEConferenceInvitationCellNode.m
//  ASDemo
//
//  Created by hzyuxiaohua on 2017/7/17.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

#import "NEConferenceInvitationCellNode.h"

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

@end

@implementation NEConferenceInvitationCellNode

- (instancetype)initWithDate:(NSString *)date location:(NSString *)location status:(NSUInteger)status
{
    if (self = [super init]) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        UIFont *font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
        NSDictionary *attr = @{ NSFontAttributeName: font, NSParagraphStyleAttributeName: style };
        
        self.status = status;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.date.attributedText = [[NSAttributedString alloc] initWithString:date attributes:attr];
        self.location.attributedText = [[NSAttributedString alloc] initWithString:location attributes:attr];
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
    
    // horizontal separator
    [self addSubnode:self.horizontal_separator];
    
    // vertical separators
    [self addSubnode:self.vertical_separator1];
    [self addSubnode:self.vertical_separator2];
    
    // buttons
    [self addSubnode:self.accept];
    [self addSubnode:self.pending];
    [self addSubnode:self.rejected];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
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
    
    // horizontal separator
    ASInsetLayoutSpec *h_separator_spec =
    [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(5, 2, 5, 2)
                                           child:self.horizontal_separator];
    
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
    
    container.children = @[date_spec, location_spec, h_separator_spec, btn_inset_spec];
    
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
        [node setTitle:@"Accept" withFont:nil withColor:nil forState:UIControlStateNormal];
        [node setTitle:@"Accept" withFont:nil withColor:nil forState:UIControlStateHighlighted];
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
        [node setTitle:@"Pending" withFont:nil withColor:nil forState:UIControlStateNormal];
        [node setTitle:@"Pending" withFont:nil withColor:nil forState:UIControlStateHighlighted];
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
        [node setTitle:@"Rejected" withFont:nil withColor:nil forState:UIControlStateNormal];
        [node setTitle:@"Rejected" withFont:nil withColor:nil forState:UIControlStateHighlighted];
        [node addTarget:self action:@selector(doRejectedAction) forControlEvents:ASControlNodeEventTouchUpInside];
        
        _rejected = node;
    }
    
    return _rejected;
}

#pragma mark - private

- (void)doAcceptAction
{
    NSLog(@"Accept");
}

- (void)doPendingAction
{
    NSLog(@"Pending");
}

- (void)doRejectedAction
{
    NSLog(@"Rejected");
}

@end
