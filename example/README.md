# Example details

README for Payeezy Apple Pay(TM) Starter Kit v 2.0
(c) 2015 First Data

## INTRODUCTION

This Xcode project builds an app that demonstrates how easy it is to enable
Apple Pay In-App payments via First Data’s Payeezy platform in your app.

The app consists of a single view controller that allows the user
to specify a transaction amount and choose to perform a pre-authorization or
purchase transaction.  The transaction is automatically routed through the Payeezy
device-side SDK and then onto the Payeezy back-end services, where it is validated
and sent through First Data’s payment processing network.

The Payeezy Apple Pay SDK is implemented as two iOS frameworks that are included in this distribution:

- InAppSDK.framework: provides all the necessary device-side processing 
   of Apple Pay transactions

- PayeezyClient.framework:  the iOS client for the Payeezy (RESTful) API
   The InAppSDK.framework requires this framework for invoking the Payeezy API

To facilitate testing your Apple Pay integration within the Xcode simulator and
on non-Apple Pay-enabled devices (i.e. anything other than an iPhone 6/+, iPad Air 2,
or iPad Mini 3) we also provide a framework that mocks the Apple Pay functionality.

## Supported Country: USA, UK

## BUILDING THE SAMPLE APP

There are two build targets in the SampleCharge project: 

   1. FDApplePaySample : Sample shows one textbox to enter amount in USD. Select Auth/Purchase as for transaction, Enter amount > 1.00 and click on Pay button. Payment sheet will pop-up with shipping details and amount of transaction.  Please let us know if you find any issue with code or running the application.  

   2. LunchToGo : Lunch to GO! is similar application but with better functionality. Click on 'Edir Consumer Order', select fast food iteams and click on 'Authorize only' or 'Make Payment'. Payment sheet will pop-up with shipping details and amount of transaction.  Please let us know if you find any issue with code or running the application. 

Both the applications are integrated with import SDK/Lib. But for your new app, you may need to add sdk/lib to your project. Check MerchantMakePaymentViewController.m -> makePaymentOrAuthorization() for implemenation details  

<div><img src="https://github.com/payeezy/payeezy_apple_pay/raw/master/guide/images/simple_app_landing_page.png" alt="sample app"/>&nbsp;&nbsp;<img src="https://github.com/payeezy/payeezy_apple_pay/raw/master/guide/images/simple_app_payment_sheet.png" alt="sample app"/>&nbsp;&nbsp;<img src="https://github.com/payeezy/payeezy_apple_pay/raw/master/guide/images/simple_app_payment_processing.png" alt="sample app"/>&nbsp;&nbsp;<img src="https://github.com/payeezy/payeezy_apple_pay/raw/master/guide/images/simple_app_payment_done.png" alt="sample app"/>&nbsp;&nbsp;<img src="https://github.com/payeezy/payeezy_apple_pay/raw/master/guide/images/simple_app_payment_confirmation.png" alt="sample app"/></div>

## OBTAINING YOUR CREDENTIALS

This sample app’s testing target is pre-configured with shared test credentials so you
can build this target and begin experimenting with Apple Pay *immediately*!!!
However, we **highly recommended** that you obtain your own test
credentials.  This requires just 5-minutes of your time and is well worth it.

To obtain your credentials (consisting of API key, API secret, merchant token), 
visit https://developer.payeezy.com, click on ‘Create Account’, and follow the steps.  
Once you receive your credentials, edit AppDelegate.h with the values for kApiKey, 
kApiSecret, and kMerchantToken with your unique credentials.

NOTE: in this demonstration app, we code these credentials directly into AppDelegate.h
This is *not* a secure practice for a production app and we recommend that you
read the Apple iOS security documentation or enlist the aid of a security expert for
guidance on how to properly secure credentials in an app.


## PRODUCTION BUILDS

Apple does not currently support a “test” environment for Apple Pay.  When you are ready
to send “live” transactions from your app you must use an active Payeezy merchant account.
You can do so through your developer account on http://developer.payeezy.com
Once you have obtained your production Payeezy credentials you will need to update the code
to send those credentials AND perform a production build via the SampleCharge-iPhone6 target.


## POINTS OF INTEREST


Much of the interesting bits of this sample resides in ViewController.m :

- The method 'payClicked' demonstrates how to construct a payment request and display
  the payment sheet through which the user authorizes the payment.  The test mode build
  provides a simple mock of the payment view that Apple Pay displays on supported devices.
  
- The implementation of the FDPaymentAuthorizationViewControllerDelegate shows how to receive
  callbacks from the SDK.  Note that you **must implement** the 
  FDPaymentAuthorizationViewControllerDelegate protocol in order to process Apple Pay
  transactions in your app.


And in AppDelegate.m :

- Your main interface to the Payeezy Apple Pay SDK is through the FDInAppPaymentProcessor
  class.  In the sample app, we create a singleton instance that is attached to 
  AppDelegate as a property.  

- When building and running in test mode, you MUST invoke the method RewrapService
 so that the mock Apple Pay service
  gets properly initialized.


## Contributing

1. Fork it 
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request  

## Feedback

Payeezy  SDK is in active development. We appreciate the time you take to try it out and welcome your feedback!
Here are a few ways to get in touch:
* [GitHub Issues](https://github.com/payeezy/payeezy/issues) - For generally applicable issues and feedback
* support@payeezy.com - for personal support at any phase of integration
* [1.855.799.0790](tel:+18557990790)  - for personal support in real time 

## Terms of Use

Terms and conditions for using Payeezy SDK: Please see [Payeezy Terms & conditions](https://developer.payeezy.com/terms-use)
 
### License
The Payeezy SDK is open source and available under the MIT license. See the LICENSE file for more info.
