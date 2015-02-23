//
//  iphoneHowlingCowScene2.m
//  foodsafetyapp
//
//  Created by jrtb on 10/21/14.
//  Copyright (c) 2014 NC State. All rights reserved.
//

#import "iphoneHowlingCowScene2.h"

#import "AppDelegate.h"
#import "GameViewController.h"

#import "UIImage+ImageEffects.h"

#import "DSMultilineLabelNode.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation iphoneHowlingCowScene2

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        touched = NO;
        menuOut = NO;
        
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
        
        //float spacing = 5.0;
        
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
        
        SKSpriteNode *top = [[SKSpriteNode alloc] initWithColor:[SKColor colorWithRed:204/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0] size:CGSizeMake(self.size.width, 52.0)];
        top.position = CGPointMake(self.size.width/2, self.size.height);
        top.anchorPoint = CGPointMake(0.5, 1.0);
        top.zPosition = 2;
        [solarSystem addChild:top];
        
        navBackButton = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"gray_back_button"];
        [navBackButton initButton];
        navBackButton.name = @"navback";
        navBackButton.delegate = self;
        navBackButton.scale = primaryScale;
        navBackButton.position = CGPointMake(self.size.width-26.0,self.size.height-26.0);
        navBackButton.zPosition = 4;
        [solarSystem addChild:navBackButton];

        menuButton = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"menu_button"];
        [menuButton initButton];
        menuButton.name = @"menu";
        menuButton.delegate = self;
        menuButton.scale = primaryScale;
        menuButton.position = CGPointMake(22.0,self.size.height-22.0);
        menuButton.zPosition = 4;
        //menuButton.color = [SKColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        //menuButton.colorBlendFactor = 1.0;
        [solarSystem addChild:menuButton];
        
        backButton = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"back_button"];
        [backButton initButton];
        backButton.name = @"back";
        backButton.delegate = self;
        backButton.scale = primaryScale;
        backButton.position = CGPointMake(22.0-self.size.width,self.size.height-22.0);
        backButton.zPosition = -1;
        backButton.enabled = NO;
        [self addChild:backButton];

        DSMultilineLabelNode *aLetter = [DSMultilineLabelNode labelNodeWithFontNamed:@"UniversLTStd-Cn"];
        aLetter.position = CGPointMake(self.size.width*.5, self.size.height-30.0);
        aLetter.text = @"Howling Cow";
        aLetter.fontSize = 18.0;
        if (IS_IPHONE_6 || IS_IPHONE_6_PLUS)
            aLetter.fontSize += 6;
        //aLetter.scale = primaryScale * buttonScale;
        aLetter.zPosition = 3;
        aLetter.fontColor = [SKColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        aLetter.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        aLetter.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [solarSystem addChild:aLetter];
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
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
        spinner.frame = CGRectMake(self.size.width*0.5, self.size.height*0.5, 60, 60);
        
        [vc.view addSubview:spinner];
        
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"HowlingCow%i",vc.careersSection] ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, top.size.height+10, self.size.width-20, self.size.height-top.size.height-20)];
        webView.delegate = self;
        webView.userInteractionEnabled = YES;
        webView.backgroundColor = [UIColor clearColor];
        webView.scalesPageToFit = YES;
        
        //NSURL *url = [NSURL URLWithString:@"http://www.ibm.com"];
        //NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
        //[webView loadRequest:request];
        
        [webView loadHTMLString:htmlString baseURL:baseURL];
        
        [vc.view addSubview:webView];
        
        SKAction *waitC = [SKAction waitForDuration:0.2];
        SKAction *goC = [SKAction runBlock:^{
            
            [self getScreenshot];
            
        }];
        [self runAction:[SKAction sequence:@[waitC,goC]]];
        
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
        /*
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
        */
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
    if (showingSpinner) {
        showingSpinner = NO;
        [spinner stopAnimating];
        [spinner removeFromSuperview];
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (showingSpinner) {
        showingSpinner = NO;
        [spinner stopAnimating];
        [spinner removeFromSuperview];
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
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        [self clean];
        
        [vc setScreenToggle:HOWLINGCOW];
        [vc replaceTheScene];
        
    }
    
}

- (void) handleSwipeGestureRight: (id) sender
{
    printf("swipe right\n");
    
    if (!menuOut) {
        
        webView.alpha = 0.0;
        
        menuOut = YES;
        
        menuButton.enabled = NO;
        [menuButton runAction:[SKAction fadeAlphaTo:0.0 duration:0.4]];
        
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

- (void) getScreenshot {
    
    AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
    
    // Create the image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width, self.size.height), NO, 0);
    
    // There he is! The new API method
    [delegate.window drawViewHierarchyInRect:CGRectMake(0,0,self.size.width,self.size.height) afterScreenUpdates:YES];
    
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
    //screenshotView.scale = 1.0 / blurredSnapshotImage.scale;
    screenshotView.position = CGPointMake(self.size.width*0.5, self.size.height*0.5);
    //screenshotView.anchorPoint = CGPointMake(1.0, 1.0);
    screenshotView.zPosition = -1;
    //screenshotView.zRotation = SK_DEGREES_TO_RADIANS(90);
    screenshotView.alpha = 0.0;
    [self addChild:screenshotView];
    
//    NSLog(@"image size %@, scale %f", NSStringFromCGSize(blurredSnapshotImage.size), blurredSnapshotImage.scale);
//    NSLog(@"texture from image, size %@", NSStringFromCGSize(screenshotView.size));
    
    // Be nice and clean your mess up
    UIGraphicsEndImageContext();
    
    
}

- (void) buttonPushed: (SKButtonNodeJRTB *) sender {
    
    if ([sender.name isEqualToString:@"overlay_01"]) {
        [self removeAllActions];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:PREREQ];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_02"]) {
        [self removeAllActions];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:HACCP2];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_03"]) {
        [self removeAllActions];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:CAREERS];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_04"]) {
        [self removeAllActions];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:HOWLINGCOW];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_05"]) {
        [self removeAllActions];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:MENU];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_06"]) {
        [self removeAllActions];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:MENU];
        [vc replaceTheScene];
    }
    
    if ([sender.name isEqualToString:@"navback"]) {
        
        //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        printf("nav back button pressed\n");
        
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
        
        menuOut = YES;
        webView.alpha = 0.0;

        menuButton.enabled = NO;
        [menuButton runAction:[SKAction fadeAlphaTo:0.0 duration:0.4]];
        
        [overlay removeAllActions];
        [overlay runAction:[SKAction moveTo:CGPointMake(self.size.width*.5-iphoneAddX, self.size.height*.5) duration:0.4]];
        
        screenshotView.zPosition = 5;
        [screenshotView runAction:[SKAction fadeAlphaTo:1.0 duration:0.4]];
        
        [backButton removeAllActions];
        backButton.zPosition = 41;
        backButton.position = CGPointMake(22.0-self.size.width,self.size.height-22.0);
        backButton.enabled = YES;
        [backButton runAction:[SKAction moveTo:CGPointMake(22.0,self.size.height-22.0) duration:0.4]];
        
    }
    
    if ([sender.name isEqualToString:@"back"]) {
        
        //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        printf("back button pressed\n");
        
        menuOut = NO;

        [menuButton removeAllActions];
        menuButton.enabled = YES;
        menuButton.color = [SKColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        menuButton.colorBlendFactor = 1.0;
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
            webView.alpha = 1;
        }];
        [self runAction:[SKAction sequence:@[waitC,goC]]];
        
        //screenshotView.alpha = 1.0;
        
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
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

- (void) clean
{
    webView.delegate = nil;
    [webView removeFromSuperview];
    
    [self.children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SKNode* child = obj;
        [child removeAllActions];
        [child removeAllChildren];
    }];
    
    [self removeAllActions];
    [self removeAllChildren];
    
}

- (void)dealloc {
    
    printf("haccp scene dealloc\n");
}

@end
