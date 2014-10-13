//
//  CalculatorBrain.m
//  TCSS598.Web.App
//
//  Created by Eugene on 10/9/14.
//  Copyright (c) 2014 University.of.Washinton. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain ()
@property (nonatomic, strong) NSMutableArray *operandStack;

@end


@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

NSDictionary *globalJsonResult;

- (NSMutableArray *)operandStack
{
    if (_operandStack == nil) _operandStack = [[NSMutableArray alloc] init];
    
    return _operandStack;

}

- (void)setOperandStack:(NSMutableArray *)operandStack
{
    _operandStack = operandStack;
}

- (void)pushOperand:(double)operand
{

    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];

    
}

- (double)popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (double)performOperation:(NSString *) operation
{
    NSLog(@"Running this loop for one time");
    double result = 0;
    //double source = 0;
    id usd_cny = 0;
    double temp_var = 0;
    //calculate below
    if ([operation isEqualToString:@"+"]){
        result = [self popOperand] + [self popOperand];
    } else if ([operation isEqualToString:@"-"]) {
        result = [self popOperand] - [self popOperand];
    } else if ([operation isEqualToString:@"Enter"]) {
        //[self popOperand];
        result = [self popOperand];
    } else if ([operation isEqualToString:@"CONVERT"]) {
        
        //source = [self popOperand];
        usd_cny = [self convertCurrency:@"usd_cny"];
        //[usd_cny doubleValue];
       // while (globalJsonResult == nil) {
       //     sleep(1);
       //     NSLog(@"sleep 1 sec before the request has been proceeded...");
       // }
     
        temp_var =[self popOperand] ;
        //NSLog(@"temp var is now %@", temp_var);
        result = temp_var * [usd_cny doubleValue];
        NSLog(@"usd_cny is now II %@", usd_cny);
        NSLog(@"result is: %f", result);
    }
    
    [self pushOperand:result];
    return result;
    
}

- (id)convertCurrency:(NSString *)usd_cny1

{
    
    NSDictionary *json;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.freecurrencyconverterapi.com/api/v2/convert?q=USD_CNY&compact=y"]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    json = [NSJSONSerialization JSONObjectWithData:response1
                                           options:0
                                             error:nil];
    NSLog(@"Sync JSON: %@", json);

   
    
    return json[@"USD_CNY"][@"val"];
}


- (id)convertCurrency1:(NSString *)usd_cny// alternative way to get request in an asynchronized manner
{
    
    //dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    id usdCnyCurrency;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.freecurrencyconverterapi.com/api/v2/convert?q=USD_CNY&compact=y"]];
    
    __block NSDictionary *json;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               json = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:nil];
                               NSLog(@"Async JSON: %@", json);
                               NSLog(@"Async JSON1: %@", json[@"USD_CNY"][@"val"]);
                               globalJsonResult = json[@"USD_CNY"][@"val"];
                               //usdCnyCurrency = json[@"USD_CNY"][@"val"];
                               //dispatch_semaphore_signal(sema);
                               
                           }];
    //dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    //dispatch_release(sema);
    NSLog(@"Async JSON: %@", json);
    NSLog(@"Async JSON1: %@", json[@"USD_CNY"][@"val"]);
    //usdCnyCurrency = json[@"USD_CNY"][@"val"];
    return usdCnyCurrency;
}

@end
