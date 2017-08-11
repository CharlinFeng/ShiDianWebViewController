//
//  CoreIV.m
//  CoreIV
//
//  Created by 冯成林 on 15/11/28.
//  Copyright © 2015年 冯成林. All rights reserved.
//

#import "CoreIV.h"
#import "DGActivityIndicatorView.h"
#import "UIView+CoreListLayout.h"

@implementation UIView (layout)

-(void)autoLayoutFillSuperView {
    
    if(self.superview == nil) {return;}
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{@"v":self};
    
    NSArray *v_ver = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[v]-0-|" options:0 metrics:nil views:views];
    NSArray *v_hor = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[v]-0-|" options:0 metrics:nil views:views];
    [self.superview addConstraints:v_ver];[self.superview addConstraints:v_hor];
}

@end



@interface CoreIV ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@property (nonatomic,assign) IVType type;

@property (nonatomic,assign) BOOL isBlack;

@property (nonatomic,weak) UIView *di;

@property (nonatomic,copy) void (^FailBlock)();

@end




@implementation CoreIV



/** 展示 */
+(void)showWithType:(IVType)type view:(UIView *)view msg:(NSString *)msg failClickBlock:(void(^)())failClickBlock{
    
    [CoreIV dismissFromView:view animated:NO];
    
    if ([NSThread mainThread]) {
        
        
        //创建view
        CoreIV *iv = [CoreIV iv];
        
        
        
        //设置
        iv.type = type;
        iv.msgLabel.text = msg;
        iv.FailBlock = failClickBlock;
        
        [view addSubview:iv];
        
        [iv autoLayoutFillSuperView];
        
    }else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //创建view
            CoreIV *iv = [CoreIV iv];
            
            
            
            //设置
            iv.type = type;
            iv.msgLabel.text = msg;
            iv.FailBlock = failClickBlock;
            
            [view addSubview:iv];
            
            [iv autoLayoutFillSuperView];
        });
    }
    
    
}

/** 展示 */
+(void)showWithType:(IVType)type view:(UIView *)view msg:(NSString *)msg isBlack:(BOOL)isBlack failClickBlock:(void(^)())failClickBlock{
    
    [CoreIV dismissFromView:view animated:NO];
    
    if([NSThread isMainThread]) {
        
        //创建view
        CoreIV *iv = [CoreIV iv];
        
        iv.isBlack = isBlack;
        
        if (isBlack) {
            
            iv.backgroundColor = [UIColor colorWithRed:32/255. green:32/255. blue:50/255. alpha:1];
            
        }else {
            
            iv.backgroundColor = [UIColor whiteColor];
        }
        
        //设置
        iv.type = type;
        iv.msgLabel.text = msg;
        iv.FailBlock = failClickBlock;
        
        [view addSubview:iv];
        
        [iv autoLayoutFillSuperView];
        
    }else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //创建view
            CoreIV *iv = [CoreIV iv];
            
            iv.isBlack = isBlack;
            
            if (isBlack) {
                
                iv.backgroundColor = [UIColor colorWithRed:32/255. green:32/255. blue:50/255. alpha:1];
                
            }else {
                
                iv.backgroundColor = [UIColor whiteColor];
            }
            
            //设置
            iv.type = type;
            iv.msgLabel.text = msg;
            iv.FailBlock = failClickBlock;
            
            [view addSubview:iv];
            
            [iv autoLayoutFillSuperView];
            
        });
        
    }
    
}


/** 消失 */
+(void)dismissFromView:(UIView *)view animated:(BOOL)animated{
    
    __block NSInteger i = 0;
    
    if ([NSThread isMainThread]) {
        for (UIView *subView in view.subviews) {
            if(![subView isKindOfClass:[CoreIV class]]) continue;
            
            if(animated){
                [UIView animateWithDuration:0.3 animations:^{
                    subView.alpha=0;
                } completion:^(BOOL finished) {
                    [(CoreIV *)subView dismiss];return;
                }];
            }else{
                [(CoreIV *)subView dismiss];break;
            }
            i++;
        }
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (UIView *subView in view.subviews) {
                if(![subView isKindOfClass:[CoreIV class]]) continue;
                
                if(animated){
                    [UIView animateWithDuration:0.3 animations:^{
                        subView.alpha=0;
                    } completion:^(BOOL finished) {
                        [(CoreIV *)subView dismiss];return;
                    }];
                }else{
                    [(CoreIV *)subView dismiss];break;
                }
                i++;
            }
        });
    }
}


/** 内部处理 */
+(instancetype)iv{
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

-(void)setType:(IVType)type {
    
    UIColor *tintColor = [UIColor colorWithRed:155/255. green:155/255. blue:155/255. alpha:1];
    CGFloat size = 28;
    CGFloat wh = 100;
    UIView *di = nil;
    
    if(type == IVTypeLoad) {
        
        DGActivityIndicatorView *di_temp = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallBeat tintColor:tintColor size:size];
        
        di = di_temp;
        
    }else {
        
        NSString *imgName = nil;
        di = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    }
    

    
    //记录
    self.di = di;
    
    [self.contentView addSubview:di];

    CGFloat x = (wh - size)/2;
    di.frame = CGRectMake(x, 0, size, size);
    
//    [di autoLayoutFillSuperView];
    
    
    if(self.type == IVTypeLoad){
        
        DGActivityIndicatorView *di_temp_2 = (DGActivityIndicatorView *)self.di;
        
        [di_temp_2 startAnimating];
    }
}

-(void)dismiss {
    
    if(self.type == IVTypeLoad){
        
        DGActivityIndicatorView *di_temp = (DGActivityIndicatorView *)self.di;
        
        [di_temp stopAnimating];
    }
    
    [self.di removeFromSuperview];
    [self removeFromSuperview];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if(self.FailBlock != nil) self.FailBlock();
}

@end
