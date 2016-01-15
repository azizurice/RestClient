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
   
    // Step-1: Built complete URL
    
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
                                              
                                              // Step-4: Handle server response
                                              [self processServerResponseUsingData:data];
                                              
                                          }];
    // Display Temporary message
    
    NSString *tempMessage= [NSString stringWithFormat:@"%@%@%@",@"Hi ",name,@" Server response will be here!!"];
    self.serverResponseLabel.text = tempMessage;
    
    // Step-3: Resume
    [dataTask setTaskDescription:@"getMessage"];
    [dataTask resume];
}


// Helper method to retrieve the required message from JSON String
- (void)processServerResponseUsingData:(NSData*)data {
    NSError *parseJsonError = nil;
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments error:&parseJsonError];
    if (!parseJsonError) {
        NSLog(@"json json data = %@", jsonDict);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            Boolean success = [jsonDict[@"success"]boolValue];
             NSLog(@"Success =%@",success? @"True": @"False");
    
            if (success){
            self.serverResponseLabel.text = jsonDict[@"data"][@"message"];
           
            
               
            } else{
                NSNumber *code= jsonDict[@"error"][@"code"];
                int statusCode=[code intValue];
                NSLog(@"Status code =%d",statusCode);
                if(statusCode == 400){
                    self.serverResponseLabel.text=jsonDict[@"error"][@"message"];
                }
            
            }
        });
    } 
}



@end
