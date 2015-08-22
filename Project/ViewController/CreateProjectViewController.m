//
//  CreateProjectViewController.m
//  Project
//
//  Created by Admin on 3/6/15.
//  Copyright (c) 2015 Qingxin. All rights reserved.
//

#import "CreateProjectViewController.h"
#import "iToast.h"

@interface CreateProjectViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textProjectName;
@end

@implementation CreateProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCreateProject:(id)sender {
    NSString *szProjectName = [self.textProjectName text];
    if ([szProjectName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [[iToast makeText:@"Please input project name"] show];
        
        return;
    }
    [self.delegate didGetProjectName:szProjectName];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
}

@end
