//
//  ViewController.m
//  testOC2
//
//  Created by csh on 16/8/5.
//  Copyright © 2016年 csh. All rights reserved.
//

#import "ViewController.h"
#import <POP/POP.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *testView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)testAc:(id)sender {
    for (int i = 0; i < 10000; i++) {
        NSLog(@"@%d",i);
        
    }
    
    [self shakeButton];
    
    
}
- (void)shakeButton
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @10000;
    positionAnimation.springBounciness = 20;
    //[positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
    // self.button.userInteractionEnabled = YES;
    //}];
    [self.testView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    NSLog(@"a");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
