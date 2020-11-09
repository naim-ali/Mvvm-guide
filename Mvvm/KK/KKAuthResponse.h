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

 
@interface KKAuthResponse : AWSModel

@property (nonatomic, strong, nullable) NSString *customerId;


@property (nonatomic, strong, nullable) NSString *loyaltyId;


@property (nonatomic, strong, nullable) NSString *firstName;


@property (nonatomic, strong, nullable) NSString *lastName;


@property (nonatomic, strong, nullable) NSString *email;


@property (nonatomic, strong, nullable) NSNumber *favoriteShopId;


@property (nonatomic, strong, nullable) NSString *voicePhone;


@property (nonatomic, strong, nullable) NSString *loyaltyCardNumber;


@property (nonatomic, strong, nullable) NSString *birthday;


@property (nonatomic, strong, nullable) NSString *loyaltyZipCode;


@property (nonatomic, strong, nullable) NSString *accessToken;


@property (nonatomic, strong, nullable) NSString *refreshToken;


@property (nonatomic, strong, nullable) NSString *expiresInSeconds;


@end
