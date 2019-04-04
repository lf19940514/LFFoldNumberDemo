//
//  LFFoldLabel.m
//  LFFoldNumberDemo
//
//  Created by souge 3 on 2019/2/13.
//  Copyright © 2019 souge 3. All rights reserved.
//
#define kBackgroundColor [UIColor colorWithRed:46/255.0f green:43/255.0f blue:46/255.0f alpha:1]
#define kTextColor [UIColor colorWithRed:186/255.0f green:183/255.0f blue:186/255.0f alpha:1]

#import "LFFoldLabel.h"

static CGFloat NextLabelStartValue = 0.01;

@interface LFFoldLabel () {
    //当前时间label
    UILabel *_timeLabel;
    //翻转动画label
    UILabel *_foldLabel;
    //下一个时间label
    UILabel *_nextLabel;
    //放置label的容器
    UIView *_labelContainer;
    //刷新UI工具
    CADisplayLink *_link;
    //动画执行进度
    CGFloat _animateValue;
}
@end

@implementation LFFoldLabel

- (instancetype)init {
    if (self = [super init]) {
        [self buildUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    _currentNum = 0;
    
    _labelContainer = [[UIView alloc] init];
    _labelContainer.backgroundColor = kBackgroundColor;
    [self addSubview:_labelContainer];
    
    _timeLabel = [[UILabel alloc] init];
    [self configLabel:_timeLabel];
    [_labelContainer addSubview:_timeLabel];
    
    _nextLabel = [[UILabel alloc] init];
    [self configLabel:_nextLabel];
    _nextLabel.hidden = true;
    //设置显示角度，为了能够显示上半部分，下半部分隐藏
    _nextLabel.layer.transform = [self nextLabelStartTransform];
    [_labelContainer addSubview:_nextLabel];
    
    
    _foldLabel = [[UILabel alloc] init];
    [self configLabel:_foldLabel];
    [_labelContainer addSubview:_foldLabel];
    
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAnimateLabel)];
    
}

- (void)configLabel:(UILabel *)label {
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kTextColor;
    label.font = _font;
    label.layer.masksToBounds = true;
    label.backgroundColor = kBackgroundColor;
    label.text = @"0";
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _labelContainer.frame = self.bounds;
    _timeLabel.frame = _labelContainer.bounds;
    _nextLabel.frame = _labelContainer.bounds;
    _foldLabel.frame = _labelContainer.bounds;
    [self setFont:[UIFont fontWithName:@"DIN Alternate" size:self.frame.size.height]];
}

#pragma mark -
#pragma mark 默认label起始角度
- (CATransform3D)nextLabelStartTransform {
    CATransform3D t = CATransform3DIdentity;
    t.m34  = CGFLOAT_MIN;
    t = CATransform3DRotate(t,M_PI * NextLabelStartValue, -1, 0, 0);
    return t;
}


#pragma mark -
#pragma mark 动画相关方法
- (void)start {
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stop {
    [_link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)updateAnimateLabel {
    _animateValue += 2/60.0f;
    if (_animateValue >= 1) {
        [self stop];
        return;
    }
    CATransform3D t = CATransform3DIdentity;
    t.m34  = CGFLOAT_MIN;
    //绕x轴进行翻转
    t = CATransform3DRotate(t, M_PI*_animateValue, -1, 0, 0);
    if (_animateValue >= 0.5) {
        //当翻转到和屏幕垂直时，翻转y和z轴
        t = CATransform3DRotate(t, M_PI, 0, 0, 1);
        t = CATransform3DRotate(t, M_PI, 0, 1, 0);
    }
    _foldLabel.layer.transform = t;
    //当翻转到和屏幕垂直时，切换动画label的字
    _foldLabel.text = _animateValue >= 0.5 ? _nextLabel.text : _timeLabel.text;
    //当翻转到指定角度时，显示下一秒的时间
    _nextLabel.hidden = _animateValue <= NextLabelStartValue;
}

#pragma mark -
#pragma mark Setter
- (void)setFont:(UIFont *)font {
    _font = font;
    
    _timeLabel.font = font;
    _foldLabel.font = font;
    _nextLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    _timeLabel.textColor = textColor;
    _foldLabel.textColor = textColor;
    _nextLabel.textColor = textColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _backgroundColor = backgroundColor;
    
    _labelContainer.backgroundColor = backgroundColor;
    _timeLabel.backgroundColor = backgroundColor;
    _foldLabel.backgroundColor = backgroundColor;
    _nextLabel.backgroundColor = backgroundColor;
}

- (void)setTextImage:(UIImage *)textImage{
    _textImage = textImage;
    
    [self setTextColor:[UIColor colorWithPatternImage:[self scaleToSize:textImage size:self.frame.size]]];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[self scaleToSize:backgroundImage size:self.frame.size]]];
}

- (void)updateNumber:(NSInteger)number nextNumber:(NSInteger)nextNumber{
    _timeLabel.text = [NSString stringWithFormat:@"%zd",number];
    _foldLabel.text = [NSString stringWithFormat:@"%zd",number];
    _nextLabel.text = [NSString stringWithFormat:@"%zd",nextNumber];
    _nextLabel.layer.transform = [self nextLabelStartTransform];
    _nextLabel.hidden = true;
    _animateValue = 0.0f;
    [self start];
    
    _currentNum = nextNumber;
}


/**
 *  改变图片的大小
 *
 *  @param image     需要改变的图片
 *  @param size 新图片的大小
 *
 *  @return 返回修改后的新图片
 */
- (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
