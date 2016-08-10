//
//  CustomeLoader.m
//  RVoice
//
//  Created by Arun Kumar on 03/02/15.
//  Copyright (c) 2015 Ril. All rights reserved.
//

#import "CustomeLoader.h"
#define View_Container_TAG 100
#define Wheel_TAG 101
#define Loader_Label_TAG 102

@implementation CustomeLoader

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup
{
    //red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.6
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    view_container = [self viewWithTag:View_Container_TAG];
    wheel = (UIImageView*)[view_container viewWithTag:Wheel_TAG];
    loader_title = (UILabel*)[view_container viewWithTag:Loader_Label_TAG];
    view_container.layer.borderWidth = 2.0;
    view_container.layer.borderColor = [UIColor whiteColor].CGColor;
   
    NSArray *array = @[ [UIImage imageNamed:@"Wheel_1"],
                        [UIImage imageNamed:@"Wheel_2"],
                        [UIImage imageNamed:@"Wheel_3"],
                        [UIImage imageNamed:@"Wheel_4"],
                        [UIImage imageNamed:@"Wheel_5"],
                        [UIImage imageNamed:@"Wheel_6"]];
    wheel.animationImages = array;
    wheel.animationDuration = 0.5;
    rectOfLabel = loader_title.frame;
}
-(void)setWidthLoaderTitleWithText:(NSString*)text
{
//    loader_title.textAlignment = NSTextAlignmentCenter;
//    loader_title.lineBreakMode = NSLineBreakByWordWrapping;
//    
//    
//    CGSize expectedLabelSize ;
//    
//    if (IS_IOS_7_OR_LESS) {
//        
//        expectedLabelSize = [text sizeWithFont:loader_title.font
//                             constrainedToSize:rectOfLabel.size
//                                 lineBreakMode:NSLineBreakByWordWrapping];
//        
//    }
//    else
//    {
//        expectedLabelSize = [text boundingRectWithSize:rectOfLabel.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : loader_title.font} context:nil].size;
//    }
//    
//    CGRect newFrame = rectOfLabel;
//    newFrame.size.height = expectedLabelSize.height;
//    loader_title.frame = rectOfLabel;
//    loader_title.numberOfLines = 0;
   // [loader_title sizeToFit];
    loader_title.text = text;
}
-(void)startAnimationOnview:(UIView*)onView
{
   
    [wheel startAnimating];
    self.frame = onView.bounds;
    self.center  = onView.center;
    [onView addSubview:self];
    
    //[onView bringSubviewToFront:self];
}
-(void)stopAnimating
{
    [wheel stopAnimating];
    [self removeFromSuperview ];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
