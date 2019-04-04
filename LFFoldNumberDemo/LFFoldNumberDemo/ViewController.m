//
//  ViewController.m
//  LFFoldNumberDemo
//
//  Created by souge 3 on 2019/2/13.
//  Copyright © 2019 souge 3. All rights reserved.
//

#import "ViewController.h"
#import "LFFoldNumber.h"

@interface ViewController ()

@property (nonatomic, strong)LFFoldNumber *foldNumber;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _foldNumber = [[LFFoldNumber alloc] initWithFrame:CGRectZero andPlaces:7 andLabelSize:CGSizeMake(42, 56) andLabelMargin:10];
    _foldNumber.center = self.view.center;
    _foldNumber.textImage = [UIImage imageNamed:@"LFFoldTextColor"];
    _foldNumber.backgroundImage = [UIImage imageNamed:@"LFFoldBackColor"];
    [self.view addSubview:_foldNumber];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    int num = arc4random()%10000000;
    _foldNumber.numberStr = [NSString stringWithFormat:@"%i",num];
}



@end
