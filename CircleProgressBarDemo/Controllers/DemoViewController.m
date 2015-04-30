//
//  ViewController.m
//  CircleProgressBar
//
//  Created by Andrew Cherkashin on 3/15/15.
//  Copyright (c) 2015 Eclair. All rights reserved.
//

#import "DemoViewController.h"
#import "CircleProgressBar.h"

@implementation DemoViewController {
    BOOL _customized;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)increaseProgress:(id)sender {
    [_circleProgressBar setProgress:(_circleProgressBar.progress + 0.06f) animated:YES];
}

- (IBAction)decreaseProgress:(id)sender {
    [_circleProgressBar setProgress:(_circleProgressBar.progress - 0.06f) animated:YES];
}

- (IBAction)customizeToggle:(id)sender {
    _customized = !_customized;
    
    // Progress Bar Customization
    [_circleProgressBar setProgressBarWidth:(_customized ? 12.0f : 0)];
    [_circleProgressBar setProgressBarProgressColor:(_customized ? [UIColor colorWithRed:0.2 green:0.7 blue:1.0 alpha:0.8] : nil)];
    [_circleProgressBar setProgressBarTrackColor:(_customized ? [UIColor colorWithWhite:0.000 alpha:0.800] : nil)];
    
    // Hint View Customization
    [_circleProgressBar setHintViewSpacing:(_customized ? 10.0f : 0)];
    [_circleProgressBar setHintViewBackgroundColor:(_customized ? [UIColor colorWithWhite:1.000 alpha:0.800] : nil)];
    [_circleProgressBar setHintAttributedTextGenerationBlock:(_customized ? ^NSAttributedString *(CGFloat progress) {
        return [self customizedHintWithProgress:progress];
    } : nil)];
    
    [_customizeButton setTitle:(_customized ? @"BACK TO DEFAULTS" : @"CUSTOMIZE") forState:UIControlStateNormal];
}

- (NSAttributedString *)customizedHintWithProgress:(CGFloat)progress
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f / 255", progress * 255]
                                                                             attributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNextCondensed-Heavy" size:40.0f],
                                                                                          NSForegroundColorAttributeName:[UIColor blackColor]}];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:[[attr string] rangeOfString:@"255"]];
    
    return attr;
}

@end
