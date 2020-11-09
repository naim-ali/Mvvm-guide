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
 

#import "KKShopsResponse_item.h"

@implementation KKShopsResponse_item

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"siteId": @"siteId",
             @"shopId": @"shopId",
             @"shopName": @"shopName",
             @"address1": @"address1",
             @"address2": @"address2",
             @"city": @"city",
             @"state": @"state",
             @"zipCode": @"zipCode",
             @"phoneNumber": @"phoneNumber",
             @"faxNumber": @"faxNumber",
             @"latitude": @"latitude",
             @"longitude": @"longitude",
             @"isClosed": @"isClosed",
             @"hoursDescriptionDineIn": @"hoursDescriptionDineIn",
             @"hoursDescriptionDriveThru": @"hoursDescriptionDriveThru",
             @"hoursDineIn": @"hoursDineIn",
             @"hoursDriveThru": @"hoursDriveThru",
             @"distance": @"distance",
             @"hotLightOn": @"hotLightOn"
             };
}

+ (NSValueTransformer *)hoursDineInJSONTransformer {
	return [NSValueTransformer awsmtl_JSONArrayTransformerWithModelClass:[KKShopsResponse_item_hoursDineIn_item class]];
}

+ (NSValueTransformer *)hoursDriveThruJSONTransformer {
	return [NSValueTransformer awsmtl_JSONArrayTransformerWithModelClass:[KKShopsResponse_item_hoursDriveThru_item class]];
}

@end
