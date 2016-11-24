//
//  XWActionSheetView.m
//  XWActionSheet
//
//  Created by Xin Wang on 11/23/16.
//  Copyright © 2016 Xin Wang. All rights reserved.
//

#import "XWActionSheetView.h"

static const CGFloat kItemHeight = 50.f;
static const CGFloat kSectionPaddingHeight = 10.f;

@class XWActionSheetItemView;

@protocol XWActionSheetItemDelegate <NSObject>

- (void)actionItemDidTouch:(XWActionSheetItemView *)itemView;

@end

@interface XWActionSheetItemView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) XWActionSheetItemType type;
@property (nonatomic, weak) id<XWActionSheetItemDelegate> delegate;
@property (nonatomic, assign) NSUInteger index;
- (instancetype)initWithFrame:(CGRect)frame type:(XWActionSheetItemType)type;
@end

@implementation XWActionSheetItemView

- (instancetype)initWithFrame:(CGRect)frame type:(XWActionSheetItemType)type
{
    if (self = [super initWithFrame:frame])
    {
        _type = type;
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _type = XWActionSheetItemNormal;
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // Line
    CGFloat lineHeight = 0.6;
    CAShapeLayer *lineLayer = [[CAShapeLayer alloc] init];
    lineLayer.frame = CGRectMake(0, kItemHeight - lineHeight, CGRectGetWidth(self.bounds), lineHeight);
    lineLayer.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1].CGColor;
    
    [self.layer addSublayer:lineLayer];
    [self addSubview:self.titleLabel];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.02];
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor whiteColor];
    if ([self.delegate respondsToSelector:@selector(actionItemDidTouch:)]) {
        [self.delegate actionItemDidTouch:self];
    }
}

@end

@interface XWActionSheetView () <XWActionSheetItemDelegate>
@property (nonatomic, copy) NSArray<NSString *> *titlesArray;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, assign) CGFloat menuHeight;
@property (nonatomic, copy) XWActionSheetTapHandler tapHandler;
@end

@implementation XWActionSheetView

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Unavailable initialization" reason:@"Please use `initWithTitles:` method." userInfo:nil];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    @throw [NSException exceptionWithName:@"Unavailable initialization" reason:@"Please use `initWithTitles:` method." userInfo:nil];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    @throw [NSException exceptionWithName:@"Unavailable initialization" reason:@"Please use `initWithTitles:` method." userInfo:nil];
    return self;
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.titlesArray = titles;
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.menuHeight = self.titlesArray.count * kItemHeight + kItemHeight + kSectionPaddingHeight;
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) + self.menuHeight, CGRectGetWidth(self.bounds), self.menuHeight)];
    self.menuView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
    
    // Add actions
    for (NSUInteger i = 0; i < self.titlesArray.count; i++) {
        CGRect itemFrame = CGRectMake(0, i * kItemHeight, self.bounds.size.width, kItemHeight);
        XWActionSheetItemView *itemView = [[XWActionSheetItemView alloc] initWithFrame:itemFrame];
        itemView.delegate = self;
        itemView.index = i;
        itemView.titleLabel.text = self.titlesArray[i];
        [self.menuView addSubview:itemView];
    }
    
    // Cancel button
    CGRect frame = CGRectMake(0, self.titlesArray.count * kItemHeight + kSectionPaddingHeight, CGRectGetWidth(self.bounds), kItemHeight);
    XWActionSheetItemView *cancelView = [[XWActionSheetItemView alloc] initWithFrame:frame type:XWActionSheetItemCancel];
    cancelView.titleLabel.text = @"取消";
    cancelView.index = self.titlesArray.count;
    cancelView.delegate = self;
    [self.menuView addSubview:cancelView];
    
    [self addSubview:self.menuView];
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.menuView.frame = ({
            CGRect frame = self.menuView.frame;
            frame.origin.y = CGRectGetHeight(self.bounds) - self.menuHeight;
            frame;
        });
    } completion:^(BOOL finished) {
        
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPoint locationInMenu = [self.menuView convertPoint:location fromView:self];
    BOOL inMenu = [self.menuView pointInside:locationInMenu withEvent:event];
    if (!inMenu) {
        [self hide];
    }
}

- (void)hide
{
    CGFloat itemsHeight = self.titlesArray.count * kItemHeight;
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.menuView.frame = ({
            CGRect frame = self.menuView.frame;
            frame.origin.y = CGRectGetHeight(self.bounds) + itemsHeight;
            frame;
        });
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)actionItemDidTouch:(XWActionSheetItemView *)itemView
{
    [self hide];
    if (self.tapHandler) {
        self.tapHandler(itemView.index, itemView.titleLabel.text, itemView.type);
        self.tapHandler = nil;
    }
}

- (void)observeTapEventWithHandler:(XWActionSheetTapHandler)handler
{
    self.tapHandler = handler;
}

@end
