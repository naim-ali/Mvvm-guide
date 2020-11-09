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
#import <AWSAPIGateway/AWSAPIGateway.h>

#import "KKSuccessResponse.h"
#import "KKChangePasswordRequest.h"
#import "KKError.h"
#import "KKCreateAccountRequest.h"
#import "KKAuthResponse.h"
#import "KKForgotPasswordRequest.h"
#import "KKSignInRequest.h"
#import "KKUpdateFavoriteShopRequest.h"
#import "KKSubscriptionsResponse.h"
#import "KKUpdateSubscriptionRequest.h"
#import "KKUpdateCustomerRequest.h"
#import "KKHealthcheckResponse.h"
#import "KKImageResponse.h"
#import "KKCardBalanceResponse.h"
#import "KKPaymentMethodsResponse.h"
#import "KKRemovePaymentMethodRequest.h"
#import "KKPaymentMethodResponse.h"
#import "KKUpdatePaymentMethodRequest.h"
#import "KKRewardsResponse.h"
#import "KKShopsResponse.h"
#import "KKShopResponse.h"


NS_ASSUME_NONNULL_BEGIN

/**
 The service client object.
 */
@interface KKAPIClient: AWSAPIGatewayClient

/**
 Returns the singleton service client. If the singleton object does not exist, the SDK instantiates the default service client with `defaultServiceConfiguration` from `[AWSServiceManager defaultServiceManager]`. The reference to this object is maintained by the SDK, and you do not need to retain it manually.

 If you want to enable AWS Signature, set the default service configuration in `- application:didFinishLaunchingWithOptions:`
 
 *Swift*

     func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
         let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "YourIdentityPoolId")
         let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialProvider)
         AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration

         return true
     }

 *Objective-C*

     - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
          AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
                                                                                                          identityPoolId:@"YourIdentityPoolId"];
          AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1
                                                                               credentialsProvider:credentialsProvider];
          [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;

          return YES;
      }

 Then call the following to get the default service client:

 *Swift*

     let serviceClient = KKAPIClient.defaultClient()

 *Objective-C*

     KKAPIClient *serviceClient = [KKAPIClient defaultClient];

 Alternatively, this configuration could also be set in the `info.plist` file of your app under `AWS` dictionary with a configuration dictionary by name `KKAPIClient`.

 @return The default service client.
 */
+ (instancetype)defaultClient;

/**
 Creates a service client with the given service configuration and registers it for the key.

 If you want to enable AWS Signature, set the default service configuration in `- application:didFinishLaunchingWithOptions:`

 *Swift*

     func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
         let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "YourIdentityPoolId")
         let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialProvider)
         KKAPIClient.registerClientWithConfiguration(configuration, forKey: "USWest2KKAPIClient")

         return true
     }

 *Objective-C*

     - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
         AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
                                                                                                         identityPoolId:@"YourIdentityPoolId"];
         AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSWest2
                                                                              credentialsProvider:credentialsProvider];

         [KKAPIClient registerClientWithConfiguration:configuration forKey:@"USWest2KKAPIClient"];

         return YES;
     }

 Then call the following to get the service client:

 *Swift*

     let serviceClient = KKAPIClient(forKey: "USWest2KKAPIClient")

 *Objective-C*

     KKAPIClient *serviceClient = [KKAPIClient clientForKey:@"USWest2KKAPIClient"];

 @warning After calling this method, do not modify the configuration object. It may cause unspecified behaviors.

 @param configuration A service configuration object.
 @param key           A string to identify the service client.
 */
+ (void)registerClientWithConfiguration:(AWSServiceConfiguration *)configuration forKey:(NSString *)key;

/**
 Retrieves the service client associated with the key. You need to call `+ registerClientWithConfiguration:forKey:` before invoking this method or alternatively, set the configuration in your application's `info.plist` file. If `+ registerClientWithConfiguration:forKey:` has not been called in advance or if a configuration is not present in the `info.plist` file of the app, this method returns `nil`.

 For example, set the default service configuration in `- application:didFinishLaunchingWithOptions:`

 *Swift*

     func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
         let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "YourIdentityPoolId")
         let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialProvider)
         KKAPIClient.registerClientWithConfiguration(configuration, forKey: "USWest2KKAPIClient")

         return true
     }

 *Objective-C*

     - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
         AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
                                                                                                         identityPoolId:@"YourIdentityPoolId"];
         AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSWest2
                                                                              credentialsProvider:credentialsProvider];

         [KKAPIClient registerClientWithConfiguration:configuration forKey:@"USWest2KKAPIClient"];

         return YES;
     }

 Then call the following to get the service client:

 *Swift*

     let serviceClient = KKAPIClient(forKey: "USWest2KKAPIClient")

 *Objective-C*

     KKAPIClient *serviceClient = [KKAPIClient clientForKey:@"USWest2KKAPIClient"];

 @param key A string to identify the service client.

 @return An instance of the service client.
 */
+ (instancetype)clientForKey:(NSString *)key;

/**
 Removes the service client associated with the key and release it.
 
 @warning Before calling this method, make sure no method is running on this client.
 
 @param key A string to identify the service client.
 */
+ (void)removeClientForKey:(NSString *)key;

/**
 
 
 @param body 
 
 return type: KKSuccessResponse *
 */
- (AWSTask *)authChangepasswordPost:( KKChangePasswordRequest *)body;

/**
 
 
 @param body 
 
 return type: KKAuthResponse *
 */
- (AWSTask *)authCreateaccountPost:( KKCreateAccountRequest *)body;

/**
 
 
 @param body 
 
 return type: KKSuccessResponse *
 */
- (AWSTask *)authForgotpasswordPost:( KKForgotPasswordRequest *)body;

/**
 
 
 @param body 
 
 return type: KKAuthResponse *
 */
- (AWSTask *)authResetpasswordPost:( KKForgotPasswordRequest *)body;

/**
 
 
 @param body 
 
 return type: KKAuthResponse *
 */
- (AWSTask *)authSigninPost:( KKSignInRequest *)body;

/**
 
 
 @param body 
 
 return type: KKSuccessResponse *
 */
- (AWSTask *)authVerifycodePost:( KKForgotPasswordRequest *)body;

/**
 
 
 @param accessToken 
 @param body 
 
 return type: KKSuccessResponse *
 */
- (AWSTask *)customerFavoriteshopUpdatePost:( NSString *)accessToken body:( KKUpdateFavoriteShopRequest *)body;

/**
 
 
 @param accessToken 
 @param deviceId 
 @param customerId 
 
 return type: KKSubscriptionsResponse *
 */
- (AWSTask *)customerSubscriptionsGet:( NSString *)accessToken deviceId:( NSString *)deviceId customerId:( NSString *)customerId;

/**
 
 
 @param accessToken 
 @param body 
 
 return type: KKSuccessResponse *
 */
- (AWSTask *)customerSubscriptionsUpdatePost:( NSString *)accessToken body:( KKUpdateSubscriptionRequest *)body;

/**
 
 
 @param accessToken 
 @param body 
 
 return type: KKSuccessResponse *
 */
- (AWSTask *)customerUpdatePost:( NSString *)accessToken body:( KKUpdateCustomerRequest *)body;

/**
 
 
 
 return type: KKHealthcheckResponse *
 */
- (AWSTask *)healthcheckGet;

/**
 
 
 @param height 
 @param width 
 @param placeholderName 
 
 return type: KKImageResponse *
 */
- (AWSTask *)imagesGet:( NSString *)height width:( NSString *)width placeholderName:( NSString *)placeholderName;

/**
 
 
 @param accessToken 
 @param loyaltyCardNumber 
 @param customerId 
 
 return type: KKCardBalanceResponse *
 */
- (AWSTask *)paymentsCardbalanceGet:( NSString *)accessToken loyaltyCardNumber:( NSString *)loyaltyCardNumber customerId:( NSString *)customerId;

/**
 
 
 @param accessToken 
 @param customerId 
 
 return type: KKPaymentMethodsResponse *
 */
- (AWSTask *)paymentsPaymentmethodsGet:( NSString *)accessToken customerId:( NSString *)customerId;

/**
 
 
 @param accessToken 
 @param body 
 
 return type: KKSuccessResponse *
 */
- (AWSTask *)paymentsPaymentmethodsRemovePost:( NSString *)accessToken body:( KKRemovePaymentMethodRequest *)body;

/**
 
 
 @param accessToken 
 @param body 
 
 return type: KKPaymentMethodResponse *
 */
- (AWSTask *)paymentsPaymentmethodsUpdatePost:( NSString *)accessToken body:( KKUpdatePaymentMethodRequest *)body;

/**
 
 
 @param cardNumber 
 
 return type: KKRewardsResponse *
 */
- (AWSTask *)rewardsAvailableGet:( NSString *)cardNumber;

/**
 
 
 @param longitude 
 @param latitude 
 @param count 
 
 return type: KKShopsResponse *
 */
- (AWSTask *)shopsGet:(nullable NSString *)longitude latitude:(nullable NSString *)latitude count:(nullable NSString *)count;

/**
 
 
 @param longitude 
 @param latitude 
 
 return type: KKShopResponse *
 */
- (AWSTask *)shopsNearestGet:( NSString *)longitude latitude:( NSString *)latitude;

/**
 
 
 @param shopId 
 @param longitude 
 @param latitude 
 
 return type: KKShopResponse *
 */
- (AWSTask *)shopsShopIdGet:( NSString *)shopId longitude:(nullable NSString *)longitude latitude:(nullable NSString *)latitude;

@end

NS_ASSUME_NONNULL_END
