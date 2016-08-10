//
//  CustomeLoader.h
//  RVoice
//
//  Created by Arun Kumar on 03/02/15.
//  Copyright (c) 2015 Ril. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomeLoader : UIView
{
    UIView *view_container;
   UIImageView *wheel;
      UILabel *loader_title;
    CGRect rectOfLabel;
    
}
-(void)setWidthLoaderTitleWithText:(NSString*)text;
-(void)startAnimationOnview:(UIView*)onView;
-(void)stopAnimating;
@end
