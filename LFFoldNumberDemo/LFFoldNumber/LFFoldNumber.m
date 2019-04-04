//
//  LFFoldNumber.m
//  LFFoldNumberDemo
//
//  Created by souge 3 on 2019/2/13.
//  Copyright © 2019 souge 3. All rights reserved.
//

#import "LFFoldNumber.h"
#import "LFFoldLabel.h"

@interface LFFoldNumber () {
    NSInteger _places;
    CGSize _labelSize;
    CGFloat _margin;
}
@property (nonatomic, strong)NSMutableArray *labelArray;

@end

@implementation LFFoldNumber

- (instancetype)initWithFrame:(CGRect)frame andPlaces:(NSInteger)places andLabelSize:(CGSize)size andLabelMargin:(CGFloat)margin{
    if (self = [super initWithFrame:frame]) {
        _places = places;
        _labelSize = size;
        _margin = margin;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, (_places*_labelSize.width)+((_places-1)*margin), _labelSize.height);
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    self.backgroundColor = [UIColor clearColor];
    
    _labelArray = [NSMutableArray array];
    for (int i = 0; i < _places; i++) {
        LFFoldLabel *foldLabel = [[LFFoldLabel alloc] init];
        foldLabel.frame = CGRectMake(i*(_labelSize.width+_margin), 0, _labelSize.width, _labelSize.height);
        [self addSubview:foldLabel];
        [_labelArray addObject:foldLabel];
    }
}


- (void)setNumberStr:(NSString *)numberStr{
    _numberStr = numberStr;
    if (numberStr.length<_places) {
        for (int i = 0; i < (_places-numberStr.length); i++) {
            _numberStr = [NSString stringWithFormat:@"0%@",_numberStr];
        }
    }
    
    NSMutableArray *arr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6"].mutableCopy;
    __weak typeof(self) weakSelf = self;
    [_labelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LFFoldLabel *label = obj;
        
        char c = [weakSelf.numberStr characterAtIndex:idx];
        NSString *str = [NSString stringWithFormat:@"%c",c];
        
        if ([str integerValue]==label.currentNum) {
            [arr removeLastObject];
        }
    }];
    
    [_labelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LFFoldLabel *label = obj;
        
        char c = [weakSelf.numberStr characterAtIndex:idx];
        NSString *str = [NSString stringWithFormat:@"%c",c];
        
        if ([str integerValue]!=label.currentNum) {
            NSInteger arc = arc4random()%arr.count;
            NSString *sec = arr[arc];
            [arr removeObjectAtIndex:arc];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([sec intValue]*0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [label updateNumber:label.currentNum nextNumber:[str integerValue]];
            });
        }
    }];
    
}

- (void)setFont:(UIFont *)font{
    _font = font;
    for (int i = 0; i < _labelArray.count; i++) {
        LFFoldLabel *label = _labelArray[i];
        label.font = font;
    }
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    for (int i = 0; i < _labelArray.count; i++) {
        LFFoldLabel *label = _labelArray[i];
        label.textColor = textColor;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _backgroundColor = backgroundColor;
    for (int i = 0; i < _labelArray.count; i++) {
        LFFoldLabel *label = _labelArray[i];
        label.backgroundColor = backgroundColor;
    }
}

- (void)setTextImage:(UIImage *)textImage{
    _textImage = textImage;
    for (int i = 0; i < _labelArray.count; i++) {
        LFFoldLabel *label = _labelArray[i];
        label.textImage = textImage;
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    for (int i = 0; i < _labelArray.count; i++) {
        LFFoldLabel *label = _labelArray[i];
        label.backgroundImage = backgroundImage;
    }
}

@end
