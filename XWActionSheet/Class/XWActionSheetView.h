//
//  XWActionSheetView.h
//  XWActionSheet
//
//  Created by Xin Wang on 11/23/16.
//  Copyright © 2016 Xin Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(uint8_t, XWActionSheetItemType)
{
    XWActionSheetItemNormal,
    XWActionSheetItemCancel,
};

typedef void (^XWActionSheetTapHandler) (NSUInteger index, NSString *title, XWActionSheetItemType type);

@interface XWActionSheetView : UIView

@property (nonatomic, copy) NSString *caption;

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles;
- (void)show;
- (void)hide;
- (void)observeTapEventWithHandler:(XWActionSheetTapHandler)handler;

@end
