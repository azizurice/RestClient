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
    
    NSString *BASE_URL=@"http://dev.addictiveadsnetwork.com/api/v1/test/hello/";
    
    // Base URL and build complete URL
   // NSString *dataUrl = @"http://dev.addictiveadsnetwork.com/api/v1/test/hello/Azizur";
    NSString *combinedURL= [NSString stringWithFormat:@"%@%@",BASE_URL,name];
    NSURL *url = [NSURL URLWithString:combinedURL];

    // Step-2: Use dataTask for anynchronous communication and handle the server response.
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              
                                              // Check Authorization status- "Not Authorized"
                                              if ([response respondsToSelector:@selector(statusCode)]) {
                                                  if ([(NSHTTPURLResponse *) response statusCode] == 403) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          // Remind the user to update the API Key
                                                          UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Authorization Needed"
                                                                                                           message:@"Contact to Michael at michael@addictiveads.com"
                                                                                                          delegate:nil
                                                                                                 cancelButtonTitle:@"OK"
                                                                                                 otherButtonTitles:nil];
                                                          [alert show];
                                                          return;
                                                      });
                                                  }
                                              }
                                              
                                              // 4: Handle server response
                                              [self processServerResponseUsingData:data];
                                              
                                          }];
    
    // 3
    [dataTask setTaskDescription:@"getMessage"];
    [dataTask resume];
}


// Helper method to retrieve the required message from JSON String
- (void)processServerResponseUsingData:(NSData*)data {
    NSError *parseJsonError = nil;
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments error:&parseJsonError];
    if (!parseJsonError) {
        NSLog(@"json data = %@", jsonDict);
        dispatch_async(dispatch_get_main_queue(), ^{
            // self.currentConditionsLabel.text = jsonDict[@"success"];
            //self.serverResponseLabel.text= @"test";
            self.serverResponseLabel.text = jsonDict[@"data"][@"message"];
        });
    }
}



@end
