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
#import "KKShopResponse_hoursDineIn_item.h"
#import "KKShopResponse_hoursDriveThru_item.h"

 
@interface KKShopResponse : AWSModel

@property (nonatomic, strong, nullable) NSNumber *siteId;


@property (nonatomic, strong, nullable) NSNumber *shopId;


@property (nonatomic, strong, nullable) NSString *shopName;


@property (nonatomic, strong, nullable) NSString *address1;


@property (nonatomic, strong, nullable) NSString *address2;


@property (nonatomic, strong, nullable) NSString *city;


@property (nonatomic, strong, nullable) NSString *state;


@property (nonatomic, strong, nullable) NSString *zipCode;


@property (nonatomic, strong, nullable) NSString *phoneNumber;


@property (nonatomic, strong, nullable) NSString *faxNumber;


@property (nonatomic, strong, nullable) NSNumber *latitude;


@property (nonatomic, strong, nullable) NSNumber *longitude;


@property (nonatomic, strong, nullable) NSNumber *isClosed;


@property (nonatomic, strong, nullable) NSString *hoursDescriptionDineIn;


@property (nonatomic, strong, nullable) NSString *hoursDescriptionDriveThru;


@property (nonatomic, strong, nullable) NSArray *hoursDineIn;


@property (nonatomic, strong, nullable) NSArray *hoursDriveThru;


@property (nonatomic, strong, nullable) NSNumber *distance;


@property (nonatomic, strong, nullable) NSNumber *hotLightOn;


@end
