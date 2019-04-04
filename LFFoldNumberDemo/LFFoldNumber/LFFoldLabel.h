//
//  LFFoldLabel.h
//  LFFoldNumberDemo
//
//  Created by souge 3 on 2019/2/13.
//  Copyright © 2019 souge 3. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFFoldLabel : UIView

- (void)updateNumber:(NSInteger)number nextNumber:(NSInteger)nextNumber;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIImage *textImage;

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, assign) NSInteger currentNum;

@end

NS_ASSUME_NONNULL_END
