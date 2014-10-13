//
//  CalculatorBrain.h
//  TCSS598.Web.App
//
//  Created by Eugene on 10/9/14.
//  Copyright (c) 2014 University.of.Washinton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *) operation;
//- (id)convertCurrency:(void);

//- (id)convertCurrency:(NSString *)usd_cny completion:(void(^)(NSDictionary *json))completion;

@end
