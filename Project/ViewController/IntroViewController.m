//
//  IntroViewController.m
//  RPG
//
//  Created by Mountain on 6/12/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "IntroViewController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void) disappearViewController
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction)onLogin:(id)sender {
    LoginViewController* pController = [[LoginViewController alloc] init];
    [self presentViewController:pController animated:YES completion:nil];
}

- (IBAction)onSignup:(id)sender {
    SignupViewController *pController = [[SignupViewController alloc] init];
    [self presentViewController:pController animated:YES completion:nil];
}

@end
