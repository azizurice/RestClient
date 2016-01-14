//
//  ViewController.m
//  RestClient
//
//  Created by Azizur Rahman on 2016-01-13.
//  Copyright © 2016 Azizur Rahman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *serverResponseLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendRequestButton:(id)sender {
    NSString *name = _nameTextField.text;
    _serverResponseLabel.text = name;
}


@end
