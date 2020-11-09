/*
 Copyright 2010-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License").
 You may not use this file except in compliance with the License.
 A copy of the License is located at

 http://aws.amazon.com/apache2.0

 or in the "license" file accompanying this file. This file is distributed
 on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 express or implied. See the License for the specific language governing
 permissions and limitations under the License.
 */
 

#import <Foundation/Foundation.h>
#import <AWSCore/AWSCore.h>

 
@interface KKUpdatePaymentMethodRequest : AWSModel

@property (nonatomic, strong, nullable) NSString *customerId;


@property (nonatomic, strong, nullable) NSString *cardNumber;


@property (nonatomic, strong, nullable) NSString *cvvCode;


@property (nonatomic, strong, nullable) NSString *expirationDate;


@property (nonatomic, strong, nullable) NSString *friendlyName;


@property (nonatomic, strong, nullable) NSString *paymentMethodId;


@property (nonatomic, strong, nullable) NSNumber *primary;


@end
