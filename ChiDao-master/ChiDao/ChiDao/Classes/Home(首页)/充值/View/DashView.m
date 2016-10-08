//
//  DashView.m
//  ChiDao
//
//  Created by 赵洋 on 16/8/16.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "DashView.h"

@interface DashView()
{
    
}

@end
@implementation DashView
@synthesize addCard = _addCard;
-(UIImageView *)imageV_IDCard{
    
    if (!_imageV_IDCard) {
        
        _imageV_IDCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, myScreenWidth-40 , 140)];
        _imageV_IDCard.layer.cornerRadius = 6;
        _imageV_IDCard.userInteractionEnabled = YES;
        _imageV_IDCard.backgroundColor = [UIColor lightGrayColor];
        
    }
    
    return _imageV_IDCard;
    
}
- (UIImageView *)addCard{
    if (!_addCard) {
        
        _addCard = [[UIImageView alloc] initWithFrame:CGRectMake((myScreenWidth-32)/2-20, (200-32)/2-30, 32 , 32)];
        _addCard.userInteractionEnabled = YES;
        _addCard.image = [UIImage imageNamed:@"addCard"];
       
    }
    
    return _addCard;
}
-(CAShapeLayer *)shapeLayer{
    
    if (!_shapeLayer) {
        
        _shapeLayer = [CAShapeLayer layer];
        
        _shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        
        _shapeLayer.fillColor = [UIColor whiteColor].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imageV_IDCard.bounds cornerRadius:6];
        
        _shapeLayer.path = path.CGPath;
        
        _shapeLayer.frame = self.imageV_IDCard.bounds;
        
        _shapeLayer.lineWidth = 1.f;
        
        _shapeLayer.lineCap = @"square";
        
        _shapeLayer.lineDashPattern = @[@4, @2];
        
    }
    
    return _shapeLayer;
}


@end
