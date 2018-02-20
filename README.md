# Payeezy Apple Pay

First Data now supports both Apple Pay In-App and Apple Pay On the Web. 

# Apple Pay - In App 

User Action: Buyer taps the Pay button in the App and selects the payment card and uses the Touch-ID to complete the transaction.

1. The Merchant App communities with merchant server and creates a transaction ID
2. The Merchant App obtains the encrypted transaction payload (The tokenized card data "DPAN", Cryptogram, and transaction details) 
   from Apple's Pass Kit Framework
3. The Merchant App sends the encrypted transaction payload to Payeezy using the Payeezy SDK
4. Payeezy decrypts the encrypted transaction payload and processes the transaction
5. Payeezy responds back to the Merchant App (Through the SDK) with either an approval or declination
6. If provided, Payeezy sends out a transaction receipt to the merchant URL (Via a Webhook)

For more information on Apple Pay - US [click here](http://www.apple.com/apple-pay/) 
and For Apple Pay - UK [click here](https://www.apple.com/uk/apple-pay/) 

#Apple Pay Supported ``Merchant's`` domicile country
Now apple pay is supported in UK as well as US. For more information on Payeezy Supported method/API [click here](https://developer.payeezy.com/select-your-integration-method) 

Use following code and country for UK <br/>
\#define CURRENCY_CODE @“GBP” <br/>
\#define COUNTRY_CODE @“UK" 

and following code and country for US<br/>
\#define CURRENCY_CODE @"USD"<br/>
\#define COUNTRY_CODE @"US"

Refer [apple_pay081215.pdf](https://github.com/payeezy/payeezy_apple_pay/raw/master/guide/apple_pay081215.pdf) for more details on Payeezy apple pay settings and configration. 

Refer [apple_pay_quick_start(2.0).pdf](https://github.com/payeezy/payeezy_apple_pay/raw/master/guide/apple_pay_quick_start(2.0).pdf) for more details on Payeezy apple pay coding.

## Sample App (with textbox and Apple Pay button)
<div><img src="https://github.com/payeezy/payeezy_apple_pay/raw/master/guide/images/simple_app_landing_page.png" alt="sample app"/>&nbsp;<img src="https://github.com/payeezy/payeezy_apple_pay/raw/master/guide/images/simple_app_payment_sheet.png" alt="sample app"/>&nbsp;<img src="https://github.com/payeezy/payeezy_apple_pay/raw/master/guide/images/simple_app_payment_processing.png" alt="sample app"/>&nbsp;<img src="https://github.com/payeezy/payeezy_apple_pay/raw/master/guide/images/simple_app_payment_done.png" alt="sample app"/>&nbsp;<img src="https://github.com/payeezy/payeezy_apple_pay/raw/master/guide/images/simple_app_payment_confirmation.png" alt="sample app"/></div>

For Code location: [click here](https://github.com/payeezy/payeezy_apple_pay/tree/master/example/FDApplePaySample)

Lunch2Go App: (with Lunch Menu and option to add and remove items with Apple Pay button)<div><img src="https://github.com/payeezy/payeezy_apple_pay/raw/master/guide/images/ltg_app_landing_page.png" alt="sample app"/>&nbsp;<img src="https://github.com/payeezy/payeezy_apple_pay/raw/master/guide/images/ltg_app_payment_sheet.png" alt="sample app"/>&nbsp;<img src="https://github.com/payeezy/payeezy_apple_pay/raw/master/guide/images/ltg_app_order_page.png" alt="sample app"/>&nbsp;<img src="https://github.com/payeezy/payeezy_apple_pay/raw/master/guide/images/ltg_app_payment_processing.png" alt="sample app"/>&nbsp;<img src="https://github.com/payeezy/payeezy_apple_pay/raw/master/guide/images/ltg_app_payment_done.png" alt="sample app"/>&nbsp;<img src="https://github.com/payeezy/payeezy_apple_pay/raw/master/guide/images/ltg_app_payment_confirmation.png" alt="sample app"/></div>

For Code location: [click here](https://github.com/payeezy/payeezy_apple_pay/tree/master/example/LunchToGo)

# Apple Pay - On the Web

User Action: Buyer clicks the Apple Pay button on the mobile Web page and then selects the payment card and any additional options (such as expedited shipping) from the Apple Pay text box. Buyer completes the transaction by using the Touch-ID on their iPhone. 

**Note:** The Apple Pay button is only displayed if the buyer has Apple Pay enabled and is using Safari as their mobile browser.

1. The  communities with merchant server and creates a transaction ID
2. The Merchant App obtains the encrypted transaction payload (The tokenized card data "DPAN", Cryptogram, and transaction details)    from Apple's Pass Kit Framework
3. The Merchant App sends the encrypted transaction payload to Payeezy using the Payeezy SDK
4. Payeezy decrypts the encrypted transaction payload and processes the transaction
5. Payeezy responds back to the Merchant App (Through the SDK) with either an approval or declination
6. If provided, Payeezy sends out a transaction receipt to the merchant URL (Via a Webhook)

## Sample App (with Apple Pay button on mobile web page, payment text box, and confirmation screens on associated iPhone)
<div><img src="https://github.com/payeezy/payeezy_apple_pay/blob/master/guide/images/ApplePayWeb-PymtPgButton.png" alt="sample app"/>&nbsp;<br>&nbsp;<img src="https://github.com/payeezy/payeezy_apple_pay/blob/master/guide/images/ApplePayWeb-PymtTextBox.png" alt="sample app"/>&nbsp;<img src="https://github.com/payeezy/payeezy_apple_pay/blob/master/guide/images/ApplePayWeb-PymtTextBox-Pymt%20Method.png" alt="sample app"/>&nbsp;<img src="https://github.com/payeezy/payeezy_apple_pay/blob/master/guide/images/ApplePayWeb-PymntTextBox-SubtotalAddition-shipping.png" alt="sample app"/>&nbsp;<img src="https://github.com/payeezy/payeezy_apple_pay/blob/master/guide/images/ApplePayWeb-PhoneConfirmScreen.png" alt="sample app"/>&nbsp;<img src="https://github.com/payeezy/payeezy_apple_pay/blob/master/guide/images/ApplePayWeb-PhoneDoneScreen.png" alt="sample app"/></div>

For Code location: [click here](https://github.com/payeezy/payeezy_apple_pay/tree/master/example/FDApplePaySample)

# Getting Started with Payeezy
Using below listed steps, you can easily integrate your mobile/web payment application with Payeezy APIs and go LIVE!
*	LITE  - REGISTRATION  
*	GET CERTIFIED
*	ADD MERCHANTS 
*	LIVE!

![alt tag](https://github.com/payeezy/get_started_with_payeezy/raw/master/payeezy_flow_diagram.png)

For more information on getting started, visit  [get_start_with_payeezy guide] (https://github.com/payeezy/get_started_with_payeezy/blob/master/get_started_with_payeezy042015.pdf) or [download](https://github.com/payeezy/get_started_with_payeezy/raw/master/get_started_with_payeezy042015.pdf)

# Testing - Payeezy {SANDBOX region}
For test credit card,eCheck,GiftCard please refer to [test data ](https://github.com/payeezy/testing_payeezy/blob/master/payeezy_testdata042015.pdf) or [download] (https://github.com/payeezy/testing_payeezy/raw/master/payeezy_testdata042015.pdf)

# Error code/response - Payeezy {SANDBOX/PROD region}
For HTTP status code, API Error codes and error description please refer to [API error code ](https://developer.payeezy.com/payeezy_new_docs/apis) and select your API

#Questions?
We're always happy to help with code or other questions you might have! Check out [FAQ page](https://developer.payeezy.com/faq-page) or call us. 

## Contributing

1. Fork it 
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request  


## Feedback
We appreciate the time you take to try out our sample code and welcome your feedback. Here are a few ways to get in touch:
* For generally applicable issues and feedback, create an issue in this repository.
* support@payeezy.com - for personal support at any phase of integration
* [1.855.799.0790](tel:+18557990790)  - for personal support in real time 

## Terms of Use

Terms and conditions for using Payeezy Apple Pay SDK: Please see [Payeezy Terms & conditions](https://developer.payeezy.com/terms-use)
 
### License
The Payeezy Apple Pay SDK is open source and available under the MIT license. See the LICENSE file for more info.
