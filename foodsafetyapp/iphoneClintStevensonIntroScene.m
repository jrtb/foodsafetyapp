//
//  iphoneClintStevensonIntroScene.m
//  foodsafetyapp
//
//  Created by jrtb on 10/21/14.
//  Copyright (c) 2014 NC State. All rights reserved.
//

#import "iphoneClintStevensonIntroScene.h"

#import "AppDelegate.h"
#import "GameViewController.h"

#import "UIImage+ImageEffects.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation iphoneClintStevensonIntroScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        menuOut = NO;
        
        touched = NO;
        
        self.backgroundColor = [SKColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        
        // primary scale is used to scale assets such that only one 4x iPad Retina asset needs to be included in the binary
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            primaryScale = 0.5;
        } else {
            primaryScale = 0.25;
        }
        
        /*
         IS_IPHONE_4 480
         IS_IPHONE_5 568
         IS_IPHONE_6 667
         IS_IPHONE_6_PLUS 736
         */
        
        if (IS_IPHONE_4) {
            iphoneAddY = (480.0-568.0)/2.0;
            iphoneAddX = (320.0-320.0)/2.0;
        }
        if (IS_IPHONE_5) {
            iphoneAddY = (568-568.0)/2.0;
            iphoneAddX = (320.0-320.0)/2.0;
        }
        if (IS_IPHONE_6) {
            iphoneAddY = (667-568.0)/2.0;
            iphoneAddX = (375.0-320.0)/2.0;
        }
        if (IS_IPHONE_6_PLUS) {
            iphoneAddY = (736-568.0)/2.0;
            iphoneAddX = (414.0-320.0)/2.0;
        }
        
        printf("iphoneAddY: %f\n",iphoneAddY);
        
        solarSystem = [[SKEffectNode alloc] init];
        solarSystem.position = CGPointMake(0.0,0.0);
        [self addChild:solarSystem];
        
        menuButton = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"menu_button"];
        [menuButton initButton];
        menuButton.name = @"menu";
        menuButton.delegate = self;
        menuButton.scale = primaryScale;
        menuButton.position = CGPointMake(22.0,self.size.height-22.0);
        menuButton.zPosition = 14;
        [self addChild:menuButton];
        
        backButton = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"back_button"];
        [backButton initButton];
        backButton.name = @"back";
        backButton.delegate = self;
        backButton.scale = primaryScale;
        backButton.position = CGPointMake(22.0-self.size.width,self.size.height-22.0);
        backButton.zPosition = -1;
        backButton.enabled = NO;
        [self addChild:backButton];
        
        navBackButton = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"green_back_button"];
        [navBackButton initButton];
        navBackButton.name = @"navback";
        navBackButton.delegate = self;
        navBackButton.scale = primaryScale;
        navBackButton.position = CGPointMake(self.size.width-26.0,self.size.height-26.0);
        navBackButton.zPosition = 4;
        [solarSystem addChild:navBackButton];

        float spacing = 5.0;
        
        float buttonSize = 152.5;
        float buttonScale = 1.0;
        if (IS_IPHONE_4) {
            buttonScale = 0.8;
            iphoneAddY += 64.0;
        }
        if (IS_IPHONE_6_PLUS) {
            buttonScale = 1.2;
            iphoneAddY -= 52.0;
        }
        buttonSize = buttonSize * buttonScale;
        
        SKSpriteNode *video1 = [SKSpriteNode spriteNodeWithImageNamed:@"clint_intro_firstframe"];
        video1.size = CGSizeMake(self.size.width, self.size.width/2.0);
        video1.anchorPoint = CGPointMake(0.5, 1.0);
        video1.position = CGPointMake(self.size.width*.5,self.size.height);
        [solarSystem addChild: video1];
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        if (showingSpinner2) {
            showingSpinner2 = NO;
            [spinner2 stopAnimating];
            [spinner2 removeFromSuperview];
        }
        showingSpinner2 = YES;
        
        spinner2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner2.color = [UIColor grayColor];
        spinner2.hidesWhenStopped = YES;
        [spinner2 startAnimating];
        spinner2.frame = CGRectMake(self.size.width*0.5, self.size.height*0.5, 60, 60);
        
        [vc.view addSubview:spinner2];
        
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"clint_stevenson_intro" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, video1.size.height+10, self.size.width-20, self.size.height-video1.size.height-20)];
        webView.delegate = self;
        webView.userInteractionEnabled = YES;
        webView.backgroundColor = [UIColor clearColor];
        webView.scalesPageToFit = YES;
        
        //NSURL *url = [NSURL URLWithString:@"http://www.ibm.com"];
        //NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
        //[webView loadRequest:request];
        
        [webView loadHTMLString:htmlString baseURL:baseURL];
        
        [vc.view addSubview:webView];

        playButton = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"play_button"];
        [playButton initButton];
        playButton.name = @"play";
        playButton.delegate = self;
        playButton.scale = primaryScale*.75;
        playButton.position = CGPointMake(self.size.width - playButton.size.width - spacing * 4,self.size.height + playButton.size.height - video1.size.height+spacing * 4);
        playButton.zPosition = 3;
        [solarSystem addChild:playButton];
        
        videoReady = NO;
        youTubeVideoReady = NO;
        
        SKAction *waitC = [SKAction waitForDuration:0.2];
        SKAction *goC = [SKAction runBlock:^{
            
            [self getScreenshot];
            
            [self setupVideo];
            
        }];
        [self runAction:[SKAction sequence:@[waitC,goC]]];
        
        youTubePlayerView = [[YTPlayerView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.size.width, self.size.height)];
        
        //youTubePlayerView.backgroundColor = [UIColor clearColor];
        
        youTubePlayerView.alpha = 0.0;
        
        [vc.view addSubview:youTubePlayerView];
        
        NSDictionary *playerVars = @{
                                     @"controls" : @2,
                                     @"playsinline" : @0,
                                     @"autohide" : @1,
                                     @"autoplay" : @1,
                                     @"fs" : @1,
                                     @"showinfo" : @0,
                                     @"modestbranding" : @1
                                     };
        youTubePlayerView.delegate = self;
        [youTubePlayerView loadWithVideoId:@"d_HkQErNXUA" playerVars:playerVars];
        
        overlay = [SKSpriteNode spriteNodeWithImageNamed:@"menu_overlay2"];
        overlay.position = CGPointMake(self.size.width/2-self.size.width, self.size.height/2);
        overlay.zPosition = 10;
        [self addChild:overlay];
        
        SKButtonNodeJRTB *overlayButton_01 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"side_menu_button_01"];
        [overlayButton_01 initButton];
        overlayButton_01.name = @"overlay_01";
        overlayButton_01.delegate = self;
        overlayButton_01.position = CGPointMake(-32.0,67.0);
        overlayButton_01.zPosition = 3;
        [overlay addChild:overlayButton_01];
        
        SKButtonNodeJRTB *overlayButton_02 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"side_menu_button_02"];
        [overlayButton_02 initButton];
        overlayButton_02.name = @"overlay_02";
        overlayButton_02.delegate = self;
        overlayButton_02.position = CGPointMake(-32.0,67.0-55.0);
        overlayButton_02.zPosition = 3;
        [overlay addChild:overlayButton_02];
        
        SKButtonNodeJRTB *overlayButton_03 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"side_menu_button_03"];
        [overlayButton_03 initButton];
        overlayButton_03.name = @"overlay_03";
        overlayButton_03.delegate = self;
        overlayButton_03.position = CGPointMake(-32.0,67.0-55.0*2);
        overlayButton_03.zPosition = 3;
        [overlay addChild:overlayButton_03];
        
        SKButtonNodeJRTB *overlayButton_04 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"side_menu_button_04"];
        [overlayButton_04 initButton];
        overlayButton_04.name = @"overlay_04";
        overlayButton_04.delegate = self;
        overlayButton_04.position = CGPointMake(-32.0,67.0-55.0*3);
        overlayButton_04.zPosition = 3;
        [overlay addChild:overlayButton_04];
        
        SKButtonNodeJRTB *overlayButton_05 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"side_menu_button_05"];
        [overlayButton_05 initButton];
        overlayButton_05.name = @"overlay_05";
        overlayButton_05.delegate = self;
        overlayButton_05.position = CGPointMake(-32.0,67.0-55.0*4);
        overlayButton_05.zPosition = 3;
        [overlay addChild:overlayButton_05];
        
        SKButtonNodeJRTB *overlayButton_06 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"side_menu_button_06"];
        [overlayButton_06 initButton];
        overlayButton_06.name = @"overlay_06";
        overlayButton_06.delegate = self;
        overlayButton_06.position = CGPointMake(-32.0,67.0-55.0*5);
        overlayButton_06.zPosition = 3;
        [overlay addChild:overlayButton_06];
        
        UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(handleSwipeGestureLeft:)];
        [vc.view addGestureRecognizer:swipeGestureLeft];
        swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        
        [swipeGestureLeft setDelegate:self];
        
        UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc]
                                                       initWithTarget:self action:@selector(handleSwipeGestureRight:)];
        swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
        [vc.view addGestureRecognizer:swipeGestureRight];
        
        [swipeGestureRight setDelegate:self];
        
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (showingSpinner2) {
        showingSpinner2 = NO;
        [spinner2 stopAnimating];
        [spinner2 removeFromSuperview];
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (showingSpinner2) {
        showingSpinner2 = NO;
        [spinner2 stopAnimating];
        [spinner2 removeFromSuperview];
    }
    
}

- (void) handleSwipeGestureLeft: (id) sender
{
    printf("swipe left\n");
    
    if (menuOut) {
        
        menuOut = NO;
        
        [menuButton removeAllActions];
        menuButton.enabled = YES;
        [menuButton runAction:[SKAction fadeAlphaTo:1.0 duration:0.4]];
        
        [overlay removeAllActions];
        [overlay runAction:[SKAction moveTo:CGPointMake(self.size.width*.5-iphoneAddX-self.size.width, self.size.height*.5) duration:0.4]];
        
        [screenshotView runAction:[SKAction fadeAlphaTo:0.0 duration:0.4]];
        
        [backButton removeAllActions];
        backButton.enabled = NO;
        [backButton runAction:[SKAction moveTo:CGPointMake(22.0-self.size.width,self.size.height-22.0) duration:0.4]];
        
        SKAction *waitC = [SKAction waitForDuration:0.4];
        SKAction *goC = [SKAction runBlock:^{
            screenshotView.zPosition = -1;
            backButton.zPosition = -1;
            webView.alpha = 1.0;
        }];
        [self runAction:[SKAction sequence:@[waitC,goC]]];
        
        //screenshotView.alpha = 1.0;
        
    } else {
        
        printf("nav back button pressed\n");
        
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:PREREQ];
        [vc replaceTheScene];
        
    }
    
}

- (void) handleSwipeGestureRight: (id) sender
{
    printf("swipe right\n");
    
    if (!menuOut) {
        
        menuOut = YES;
        
        webView.alpha = 0.0;

        menuButton.enabled = NO;
        [menuButton runAction:[SKAction fadeAlphaTo:0.0 duration:0.4]];
        
        [self removeAllActions];
        [self stopMovie];
        
        [overlay removeAllActions];
        [overlay runAction:[SKAction moveTo:CGPointMake(self.size.width*.5-iphoneAddX, self.size.height*.5) duration:0.4]];
        
        screenshotView.zPosition = 5;
        [screenshotView runAction:[SKAction fadeAlphaTo:1.0 duration:0.4]];
        
        [backButton removeAllActions];
        backButton.zPosition = 41;
        backButton.position = CGPointMake(22.0-self.size.width,self.size.height-22.0);
        backButton.enabled = YES;
        [backButton runAction:[SKAction moveTo:CGPointMake(22.0,self.size.height-22.0) duration:0.4]];
        
        //screenshotView.alpha = 1.0;
        
    }
    
}

- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView {
    
    youTubeVideoReady = YES;
    printf("youtube video ready\n");
    
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state) {
        case kYTPlayerStatePlaying:
            NSLog(@"Started playback");
            youTubePlayerView.alpha = 1.0;
            break;
        case kYTPlayerStatePaused:
            NSLog(@"Paused playback");
            youTubePlayerView.delegate = nil;
            [youTubePlayerView removeFromSuperview];
            if (showingSpinner) {
                showingSpinner = NO;
                [spinner stopAnimating];
                [spinner removeFromSuperview];
            }
            [playButton setEnabled:YES];
            [playButton runAction:[SKAction fadeAlphaTo:1.0 duration:0.4]];
            break;
        case kYTPlayerStateEnded:
            NSLog(@"Ended playback");
            youTubePlayerView.delegate = nil;
            [youTubePlayerView removeFromSuperview];
            if (showingSpinner) {
                showingSpinner = NO;
                [spinner stopAnimating];
                [spinner removeFromSuperview];
            }
            [playButton setEnabled:YES];
            [playButton runAction:[SKAction fadeAlphaTo:1.0 duration:0.4]];
            break;
        default:
            break;
    }
}

- (void) setupVideo
{
    AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
    
    videoLength = 673.0+2.0;
    
    //int actualMovieNum = 0;
    
    [vc resetVideo:@"clint_intro_small"];
    
    [[vc video] pause];
    
    [[vc video] setPosition:CGPointMake(self.size.width*.5,self.size.height)];
    [[vc video] setAnchorPoint:CGPointMake(0.5, 1.0)];
    [[vc video] setSize:CGSizeMake(self.size.width, self.size.width/2.0)];
    //[[vc video] setScale:primaryScale];
    [[vc video] setZPosition:2];
    [[vc video] setAlpha:0.0];
    [self addChild:[vc video]];
    
    videoReady = YES;
    
}

- (void) stopMovie
{
    
    if (videoReady) {
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        [vc killVideo];
        
        [[vc player] removeAllItems];
        [[vc video] removeFromParent];
        
        [playButton setEnabled:YES];
        [playButton runAction:[SKAction fadeAlphaTo:1.0 duration:0.4]];
        
        videoReady = NO;
        
    }
    
}

- (void) getScreenshot2 {
    
    AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
    
    // Create the image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.height, self.size.width), NO, 0);
    
    // There he is! The new API method
    [delegate.window drawViewHierarchyInRect:CGRectMake(0,0,self.size.height, self.size.width) afterScreenUpdates:YES];
    
    // Get the snapshot
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Or apply any other effects available in "UIImage+ImageEffects.h"
    // UIImage *blurredSnapshotImage = [snapshotImage applyDarkEffect];
    // UIImage *blurredSnapshotImage = [snapshotImage applyExtraLightEffect];
    
    screenshot = snapshotImage;
    
    // Now apply the blur effect using Apple's UIImageEffect category
    UIImage *blurredSnapshotImage = [screenshot applyLightEffect];
    
    // Or apply any other effects available in "UIImage+ImageEffects.h"
    // UIImage *blurredSnapshotImage = [snapshotImage applyDarkEffect];
    // UIImage *blurredSnapshotImage = [snapshotImage applyExtraLightEffect];
    
    screenshotView = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:blurredSnapshotImage]];
    screenshotView.scale = 1.0 / blurredSnapshotImage.scale;
    screenshotView.position = CGPointMake(self.size.width, self.size.height);
    //screenshotView.anchorPoint = CGPointMake(1.0, 1.0);
    screenshotView.zPosition = 5;
    screenshotView.alpha = 0.0;
    [self addChild:screenshotView];
    
    NSLog(@"image size %@, scale %f", NSStringFromCGSize(blurredSnapshotImage.size), blurredSnapshotImage.scale);
    NSLog(@"texture from image, size %@", NSStringFromCGSize(screenshotView.size));
    
    // Be nice and clean your mess up
    UIGraphicsEndImageContext();
    
    
}

- (void) getScreenshot {
    
    //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
    
    CGSize imageSize = CGSizeZero;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    screenshot = UIGraphicsGetImageFromCurrentImageContext();
    
    // Now apply the blur effect using Apple's UIImageEffect category
    UIImage *blurredSnapshotImage = [screenshot applyLightEffect];
    
    // Or apply any other effects available in "UIImage+ImageEffects.h"
    // UIImage *blurredSnapshotImage = [snapshotImage applyDarkEffect];
    // UIImage *blurredSnapshotImage = [snapshotImage applyExtraLightEffect];
    
    screenshotView = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:blurredSnapshotImage]];
    //screenshotView.scale = blurredSnapshotImage.scale / 3.0;
    screenshotView.position = CGPointMake(self.size.width*.5, self.size.height*.5);
    screenshotView.zPosition = -1;
    screenshotView.alpha = 0.0;
    [self addChild:screenshotView];
    
    //NSLog(@"image size %@, scale %f", NSStringFromCGSize(blurredSnapshotImage.size), blurredSnapshotImage.scale);
    //NSLog(@"texture from image, size %@", NSStringFromCGSize(screenshotView.size));
    
    UIGraphicsEndImageContext();
    
    printf("screenshot ready\n");
    
}

- (void) buttonPushed: (SKButtonNodeJRTB *) sender {
    
    if ([sender.name isEqualToString:@"overlay_01"]) {
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:PREREQ];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_02"]) {
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:HACCP];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_03"]) {
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:CAREERS];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_04"]) {
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:HOWLINGCOW];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_05"]) {
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:MENU];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_06"]) {
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:MENU];
        [vc replaceTheScene];
    }
    
    if ([sender.name isEqualToString:@"navback"]) {
        [self removeAllActions];
        [self stopMovie];

        printf("nav back button pressed\n");
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        [self clean];
        
        [vc setScreenToggle:PREREQ];
        [vc replaceTheScene];
        
    }

    if ([sender.name isEqualToString:@"01"]) {
        
        //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        printf("prereq button pressed\n");
        
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        [self clean];
        
        [vc setScreenToggle:PREREQ];
        [vc replaceTheScene];
        
    }
    
    if ([sender.name isEqualToString:@"02"]) {
        
        //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        printf("haccp button pressed\n");
        
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        [self clean];
        
        [vc setScreenToggle:HACCP];
        [vc replaceTheScene];
        
    }
    
    if ([sender.name isEqualToString:@"03"]) {
        
        //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        printf("careers button pressed\n");
        
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        [self clean];
        
        [vc setScreenToggle:CAREERS];
        [vc replaceTheScene];
        
    }
    
    if ([sender.name isEqualToString:@"04"]) {
        
        //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        printf("howling cow button pressed\n");
        
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        [self clean];
        
        [vc setScreenToggle:HOWLINGCOW];
        [vc replaceTheScene];
        
    }
    
    if ([sender.name isEqualToString:@"menu"]) {
        
        //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        printf("menu button pressed\n");
        
        if (!menuOut) {
            
            menuOut = YES;
            
            menuButton.enabled = NO;
            [menuButton runAction:[SKAction fadeAlphaTo:0.0 duration:0.4]];
            
            [self removeAllActions];
            [self stopMovie];
            
            [overlay removeAllActions];
            [overlay runAction:[SKAction moveTo:CGPointMake(self.size.width*.5-iphoneAddX, self.size.height*.5) duration:0.4]];
            
            screenshotView.zPosition = 5;
            [screenshotView runAction:[SKAction fadeAlphaTo:1.0 duration:0.4]];
            
            [backButton removeAllActions];
            backButton.zPosition = 41;
            backButton.position = CGPointMake(22.0-self.size.width,self.size.height-22.0);
            backButton.enabled = YES;
            [backButton runAction:[SKAction moveTo:CGPointMake(22.0,self.size.height-22.0) duration:0.4]];
            
            //screenshotView.alpha = 1.0;
            
        }
        
    }
    
    if ([sender.name isEqualToString:@"back"]) {
        
        //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        printf("back button pressed\n");
        
        if (menuOut) {
            
            menuOut = NO;
            
            [menuButton removeAllActions];
            menuButton.enabled = YES;
            [menuButton runAction:[SKAction fadeAlphaTo:1.0 duration:0.4]];
            
            [overlay removeAllActions];
            [overlay runAction:[SKAction moveTo:CGPointMake(self.size.width*.5-iphoneAddX-self.size.width, self.size.height*.5) duration:0.4]];
            
            [screenshotView runAction:[SKAction fadeAlphaTo:0.0 duration:0.4]];
            
            [backButton removeAllActions];
            backButton.enabled = NO;
            [backButton runAction:[SKAction moveTo:CGPointMake(22.0-self.size.width,self.size.height-22.0) duration:0.4]];
            
            SKAction *waitC = [SKAction waitForDuration:0.4];
            SKAction *goC = [SKAction runBlock:^{
                screenshotView.zPosition = -1;
                backButton.zPosition = -1;
            }];
            [self runAction:[SKAction sequence:@[waitC,goC]]];
            
            //screenshotView.alpha = 1.0;
            
        }
        
    }
    
    if ([sender.name isEqualToString:@"play"]) {
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        if (youTubeVideoReady) {
            
            [playButton setEnabled:NO];
            [playButton runAction:[SKAction fadeAlphaTo:0.0 duration:0.4]];
            
            if (showingSpinner) {
                showingSpinner = NO;
                [spinner stopAnimating];
                [spinner removeFromSuperview];
            }
            showingSpinner = YES;
            
            spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            spinner.color = [UIColor grayColor];
            spinner.hidesWhenStopped = YES;
            [spinner startAnimating];
            spinner.frame = CGRectMake(self.size.width - playButton.size.width - 5 * 4-30,self.size.height-(self.size.height + playButton.size.height - self.size.width/2.0+5 * 4)-30, 60, 60);
            
            UIViewController *vc = self.view.window.rootViewController;
            
            [vc.view addSubview:spinner];
            
            [[UIDevice currentDevice] setValue:
             [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                        forKey:@"orientation"];
            
            [youTubePlayerView playVideo];
            
        } else if (videoReady) {
            
            [playButton setEnabled:NO];
            [playButton runAction:[SKAction fadeAlphaTo:0.0 duration:0.4]];
            
            SKAction *waitC = [SKAction waitForDuration:0.4];
            SKAction *goC = [SKAction runBlock:^{
                //printf("attempting to play\n");
                [[vc video] setSize:CGSizeMake(self.size.width, self.size.width/2.0)];
                [[vc video] setAlpha:1.0];
                [[vc video] play];
                //[[vc player] play];
            }];
            [self runAction:[SKAction sequence:@[waitC,goC]]];
            
            SKAction *waitD = [SKAction waitForDuration:videoLength];
            SKAction *goD = [SKAction runBlock:^{
                //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
                //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
                
                [self stopMovie];
                
            }];
            [self runAction:[SKAction sequence:@[waitD,goD]]];
            
        }
        
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    printf("touched A\n");
    
    //if (!touched) {
    
    touched = YES;
    
    printf("touched B\n");
    
    if (menuOut) {
        
        menuOut = NO;
        
        [menuButton removeAllActions];
        menuButton.enabled = YES;
        [menuButton runAction:[SKAction fadeAlphaTo:1.0 duration:0.4]];
        
        [overlay removeAllActions];
        [overlay runAction:[SKAction moveTo:CGPointMake(self.size.width*.5-iphoneAddX-self.size.width, self.size.height*.5) duration:0.4]];
        
        [screenshotView runAction:[SKAction fadeAlphaTo:0.0 duration:0.4]];
        
        [backButton removeAllActions];
        backButton.enabled = NO;
        [backButton runAction:[SKAction moveTo:CGPointMake(22.0-self.size.width,self.size.height-22.0) duration:0.4]];
        
        SKAction *waitC = [SKAction waitForDuration:0.4];
        SKAction *goC = [SKAction runBlock:^{
            screenshotView.zPosition = -1;
            backButton.zPosition = -1;
        }];
        [self runAction:[SKAction sequence:@[waitC,goC]]];
        
        //screenshotView.alpha = 1.0;
        
    }
    
    //}
}

- (void) clean
{
    webView.delegate = nil;
    [webView removeFromSuperview];

    if (youTubePlayerView != nil) {
        youTubePlayerView.delegate = nil;
        [youTubePlayerView removeFromSuperview];
    }
    
    if (showingSpinner) {
        showingSpinner = NO;
        [spinner stopAnimating];
        [spinner removeFromSuperview];
    }

    if (showingSpinner2) {
        showingSpinner2 = NO;
        [spinner2 stopAnimating];
        [spinner2 removeFromSuperview];
    }

    [self.children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SKNode* child = obj;
        [child removeAllActions];
        [child removeAllChildren];
    }];
    
    [self removeAllActions];
    [self removeAllChildren];
    
}

- (void)dealloc {
    
    printf("clint intro scene dealloc\n");
}

@end
