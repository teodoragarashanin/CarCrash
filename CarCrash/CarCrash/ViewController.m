//
//  ViewController.m
//  CarCrash
//
//  Created by Djuro Alfirevic on 4/22/16.
//  Copyright © 2016 Djuro Alfirevic. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController()
@property (weak, nonatomic) IBOutlet UIImageView *lampImageView;
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property(strong, nonatomic) NSTimer *timer;
@end

@implementation ViewController

#pragma mark - Private API

- (void)playSound {
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"alert" ofType:@"mp3"];
    NSURL *pathURL = [NSURL fileURLWithPath :path];
    
    SystemSoundID audioEffect;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pathURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
    
    //AudioServicesDisposeSystemSoundID(audioEffect);
}

- (void)moveImage:(UIImageView *)image duration:(NSTimeInterval)duration
            curve:(int)curve x:(CGFloat)x y:(CGFloat)y {
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-x, y);
    image.transform = transform;
    
    [UIView commitAnimations];
}
-(void)setFrame {
    CGRect myFrame =self.carImageView.frame;
    myFrame.origin.x = self.lampImageView.frame.origin.x;
    self.carImageView.frame = myFrame;


}

#pragma mark - Timer

- (void) startTimer {
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:3.5
                                                    target:self
                                                  selector:@selector(timerFired:)
                                                  userInfo:nil
                                                   repeats:YES];
}

- (void) stopTimer {
    [self.myTimer invalidate];
}

- (void) timerFired:(NSTimer*)theTimer {

    if((self.carImageView.frame.origin.x > -1150.0) || (CGRectIntersectsRect(self.carImageView.frame,self.lampImageView.frame)) ) {
    [self playSound];
    [self stopTimer];
    [self setFrame];
       // [self.carImageView.frame.origin.x setFrame];
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    self.lampImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    });
    }
}

#pragma mark - View lifecycle

-(void)viewDidLoad {
    
        [super viewDidLoad];
    
        [self moveImage:self.carImageView duration:5.0 curve: UIViewAnimationCurveLinear x:1200.0 y:0.0];
        [self startTimer];
}

@end