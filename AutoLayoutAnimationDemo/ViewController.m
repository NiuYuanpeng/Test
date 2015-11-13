//
//  ViewController.m
//  AutoLayoutAnimationDemo
//
//  Created by 牛元鹏 on 15/11/13.
//  Copyright © 2015年 牛元鹏. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextView *hiddenView;
@property (nonatomic, strong) UISwitch *switchToggle;

@property (nonatomic, strong) NSArray *hiddenConstraints;
@property (nonatomic, strong) NSArray *showConstraints;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUpViews];
    
    [self setUpContraints];
}

- (void)setUpViews
{
    self.view.backgroundColor = [UIColor grayColor];
    
    NSString *text = @"hello world,@property (nonatomic, strong) UITextView *textView,@property (nonatomic, strong) UITextView *hiddenView,@property (nonatomic, strong) UISwitch *switchToggle;@property (nonatomic, strong) NSArray *hiddenConstraints;@property (nonatomic, strong) NSArray *showConstraints;@end@implementation ViewController";
    // 隐藏的
    _hiddenView = [[UITextView alloc] init];
    _hiddenView.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",text,text,text,text,text];
    // 显示的
    _textView = [[UITextView alloc] init];
    _textView.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",text,text,text,text,text,text,text];
    
    // 切换开关
    _switchToggle = [[UISwitch alloc] init];
    [_switchToggle addTarget:self action:@selector(toggleEvent:) forControlEvents:UIControlEventValueChanged];
}

- (void)setUpContraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_hiddenView,_textView,_switchToggle);
    for (UIView *view in [views allValues]) {
        [self.view addSubview:view];
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    // 添加水平约束
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_hiddenView]-|" options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_textView]-|" options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_switchToggle]-|" options:0 metrics:0 views:views]];
    
    // 添加垂直约束
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_hiddenView]" options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_textView]-[_switchToggle]-|" options:0 metrics:0 views:views]];
    
    // 创建隐藏的约束
    _hiddenConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_hiddenView(==0)]-[_textView]" options:0 metrics:0 views:views];
    
    // 创建显示的约束
    _showConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_hiddenView(_textView)][_textView]" options:0 metrics:0 views:views];
    
    [self.view addConstraints:_hiddenConstraints];
    _hiddenView.alpha = 0.0;
}

#pragma mark - touch switch event
- (void)toggleEvent:(UISwitch *)sender
{
    [UIView animateWithDuration:0.8 animations:^{
        if (!_switchToggle.on) {
            [self.view removeConstraints:_showConstraints];
            [self.view addConstraints:_hiddenConstraints];
            _hiddenView.alpha = 0.0;
        }else{
            [self.view removeConstraints:_hiddenConstraints];
            [self.view addConstraints:_showConstraints];
            _hiddenView.alpha = 1.0;
        }
        // 关键点：更新约束布局
        [self.view layoutIfNeeded];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
