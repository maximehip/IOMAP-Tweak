#import "UIDraggableWindow.h"
#import "CDTContextHostProvider.h"


@implementation UIDraggableWindow;

CDTContextHostProvider *contextProvider = [[CDTContextHostProvider alloc] init];
UIView *contextView;
NSString *openApplication;
CGPoint initialTouch;

//Move window when window head is dragged
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self];
    self.frame = CGRectMake(self.frame.origin.x + location.x - initialTouch.x, self.frame.origin.y + location.y - initialTouch.y, self.frame.size.width, self.frame.size.height);
}

//Move window to front and set initial touch point when window head is touched
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *aTouch = [touches anyObject];
    initialTouch = [aTouch locationInView:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
}


//Initialize window and display application
- (id)initWithFrameAndApp:(CGRect)frame withApplication:(NSString *)application {
    self = [super initWithFrame:frame];
    openApplication = application;
    [self setBackgroundColor:[UIColor colorWithRed:(247.0f/255.0f) green:(247.0f/255.0f) blue:(247.0f/255.0f) alpha:1]];
    [self setHidden:NO];
    self.layer.cornerRadius = 10;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.3f;
    self.layer.shadowPath = shadowPath.CGPath;
    
    //Button for closing the window
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTitle:@"X" forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(0, 0, 44, 44);
    [self addSubview:closeButton];
    
    //Display the application once the app closing animation is finished
    //Cheap way to avoid a bug where the window would only display a black view
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        //Load application into window boddy
        contextView = [contextProvider hostViewForApplicationWithBundleID:openApplication];
        [contextProvider setStatusBarHidden:@(1) onApplicationWithBundleID:openApplication];
        [contextProvider enableBackgroundingForApplication:[[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:openApplication]];
        
        [contextView setBackgroundColor:[UIColor clearColor]];
        contextView.frame = CGRectMake(0, 44, self.frame.size.width, self.frame.size.height - 44);
        contextView.clipsToBounds = YES;
        [self addSubview:contextView];
    });
    
    return self;
}

//Close window
- (void)close:(UIButton *)button{
    [self removeFromSuperview];
}

@end
