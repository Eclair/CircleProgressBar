CircleProgressBar
=================

Circle Progress Bar iOS Control.

Require iOS 7.0+ or tvOS 9.0+

![CircleProgressBar Screenshot-iOS-Example](https://raw.githubusercontent.com/Eclair/CircleProgressBar/master/Screenshots/ios-screen01.png)
![CircleProgressBar Screenshot-iOS-Example2](https://raw.githubusercontent.com/Eclair/CircleProgressBar/master/Screenshots/ios-screen02.png)

Installation
============

You can install this control in two ways:

1. Using CocoaPods:

```ruby
pod 'CircleProgressBar', '~> 0.32’
```

2. Manually:

  Download source from this repository and copy CircleProgressBarDemo/CircleProgressBar folder to your project.

	Don't forget to add _*UIKit*_ and _*QuartzCore*_ frameworks to your project.

How to use
==========

_NOTE: If you installed this control manually - please be sure that you've added UIKit and QuartzCore frameworks to your project._

_NOTE: If you're using rectangular view for CircleProgressBar control instead of square, ProgressBar will fit available area and will be drawn in center of it._

You can simply add UIView in Interface Builder to your controller and change it's class to "CircleProgressBar" (overridden _initWithCoder_ method will be called) or create CircleProgressBar programmatically using _init_ or _initWithFrame_ methods.

Using Interface Builder you'll take advantage of Xcode 6 new live rendering feature to customize control according to your needs on the fly (will be explained below in "Customization" section).

To change progress, simply call "setProgress:animated:" method of CircleProgressBar instance:

```objective-c
[_circleProgressBar setProgress:(CGFloat)progress animated:(BOOL)animated];
```

or "setProgress:animated:duration:" method to define custom animation time:

```objective-c
[_circleProgressBar setProgress:(CGFloat)progress animated:(BOOL)animated duration:(CGFloat)duration];
```

To check if there is ongoing animation use `isAnimating` property.
To stop an ongoing animation, you can use `stopAnimation` method. In this case it will set the progress to animation end value:

```objective-c
[_circleProgressBar stopAnimation];
```

Customization
=============

CircleProgressBar provides many customization properties:

```objective-c
// Progress Bar Customization
@property (nonatomic) CGFloat progressBarWidth;
@property (nonatomic) UIColor *progressBarProgressColor;
@property (nonatomic) UIColor *progressBarTrackColor;
@property (nonatomic) CGFloat startAngle;

// Hint View Customization (inside progress bar)
@property (nonatomic) BOOL hintHidden;
@property (nonatomic) CGFloat hintViewSpacing;
@property (nonatomic) UIColor *hintViewBackgroundColor;
@property (nonatomic) UIFont *hintTextFont;
@property (nonatomic) UIColor *hintTextColor;
```

Using these customization properties you can define Progress Bar's width, color of filled part, color of empty part, Progress Bar's start angle, Hint View's spacing (between progress bar and hint view), background color, hint text color and hint text font.

If you want to hide HintView you can simply set hintHidden property to NO.

To customize text inside HintView you can simply set TextGenerationBlock:

```objective-c
- (void)setHintTextGenerationBlock:(StringGenerationBlock)generationBlock;
```

For example this way:

```objective-c
[_circleProgressBar setHintTextGenerationBlock:^NSString *(CGFloat progress) {
  return [NSString stringWithFormat:@"%.0f / 255", progress * 255];
}];
```

If you want to use NSAttributedString you can set instead HintAttributedGenerationBlock:

```objective-c
- (void)setHintAttributedGenerationBlock:(AttributedStringGenerationBlock)generationBlock;
```

If you using Interface Builder, you can take an advantage of Xcode 6 live render with IBDesignable and IBInspectable features to customize control:

![CircleProgressBar Screenshot-Xcode-InterfaceBuilder](https://raw.githubusercontent.com/Eclair/CircleProgressBar/master/Screenshots/xcode-screen01.png)

License (MIT)
=============

Copyright (c) 2015 Cherkashin Andrey

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
