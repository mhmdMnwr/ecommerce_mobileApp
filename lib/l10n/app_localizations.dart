import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Grossist Bouchentouf'**
  String get appTitle;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @profileInformation.
  ///
  /// In en, this message translates to:
  /// **'Profile information'**
  String get profileInformation;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @ordersHistory.
  ///
  /// In en, this message translates to:
  /// **'Orders history'**
  String get ordersHistory;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get notLoggedIn;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @editPassword.
  ///
  /// In en, this message translates to:
  /// **'Edit Password'**
  String get editPassword;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @passwordReset.
  ///
  /// In en, this message translates to:
  /// **'Password Reset'**
  String get passwordReset;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get oldPassword;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @atLeast6Chars.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get atLeast6Chars;

  /// No description provided for @newPasswordConfirmation.
  ///
  /// In en, this message translates to:
  /// **'New password confirmation'**
  String get newPasswordConfirmation;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get passwordUpdated;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @pressBackAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get pressBackAgainToExit;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'you don\'t have an account yet'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account ?'**
  String get alreadyHaveAccount;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get deliveryAddress;

  /// No description provided for @orText.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orText;

  /// No description provided for @selectLocationOnMap.
  ///
  /// In en, this message translates to:
  /// **'Select exact location on map'**
  String get selectLocationOnMap;

  /// No description provided for @locationSelected.
  ///
  /// In en, this message translates to:
  /// **'📍 Location selected'**
  String get locationSelected;

  /// No description provided for @pleaseProvideAddress.
  ///
  /// In en, this message translates to:
  /// **'Please provide an address or select a location on the map'**
  String get pleaseProvideAddress;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @detectingLocation.
  ///
  /// In en, this message translates to:
  /// **'Detecting your location...'**
  String get detectingLocation;

  /// No description provided for @tapMapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap on the map to select your location'**
  String get tapMapToSelect;

  /// No description provided for @selectedLocation.
  ///
  /// In en, this message translates to:
  /// **'Selected Location'**
  String get selectedLocation;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocation;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @usernameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get usernameMinLength;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Phone must start with 05, 06, or 07 (10 digits)'**
  String get phoneInvalid;

  /// No description provided for @addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get addressRequired;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginFailed;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registrationFailed;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Profile update failed.'**
  String get profileUpdateFailed;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Please log in.'**
  String get registrationSuccess;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @changeLocation.
  ///
  /// In en, this message translates to:
  /// **'Change Location'**
  String get changeLocation;

  /// No description provided for @locationNotSet.
  ///
  /// In en, this message translates to:
  /// **'Location not set'**
  String get locationNotSet;

  /// No description provided for @locationSet.
  ///
  /// In en, this message translates to:
  /// **'Location set'**
  String get locationSet;

  /// No description provided for @storeName.
  ///
  /// In en, this message translates to:
  /// **'Grossist Bouchentouf'**
  String get storeName;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back !'**
  String get welcomeBack;

  /// No description provided for @newProducts.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newProducts;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @viewMore.
  ///
  /// In en, this message translates to:
  /// **'View More'**
  String get viewMore;

  /// No description provided for @failedToLoadData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data.'**
  String get failedToLoadData;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'DA'**
  String get currency;

  /// No description provided for @brands.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get brands;

  /// No description provided for @boxes.
  ///
  /// In en, this message translates to:
  /// **'Boxes'**
  String get boxes;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

  /// No description provided for @boxContainsUnits.
  ///
  /// In en, this message translates to:
  /// **'1 Box = {count} unit'**
  String boxContainsUnits(int count);

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// No description provided for @max.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get max;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @newestProducts.
  ///
  /// In en, this message translates to:
  /// **'Newest Products'**
  String get newestProducts;

  /// No description provided for @bestSelling.
  ///
  /// In en, this message translates to:
  /// **'Best Selling'**
  String get bestSelling;

  /// No description provided for @cartItems.
  ///
  /// In en, this message translates to:
  /// **'Cart items'**
  String get cartItems;

  /// No description provided for @removeAll.
  ///
  /// In en, this message translates to:
  /// **'Remove All'**
  String get removeAll;

  /// No description provided for @clearCartConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all items from your cart?'**
  String get clearCartConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @productsTotal.
  ///
  /// In en, this message translates to:
  /// **'Products total'**
  String get productsTotal;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeOrder;

  /// No description provided for @updateOrder.
  ///
  /// In en, this message translates to:
  /// **'Update Order'**
  String get updateOrder;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @cartEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Browse products and add items to your cart to get started.'**
  String get cartEmptyMessage;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart!'**
  String get addedToCart;

  /// No description provided for @pleaseWaitOrderRegistered.
  ///
  /// In en, this message translates to:
  /// **'Please wait while your order gets registered'**
  String get pleaseWaitOrderRegistered;

  /// No description provided for @orderRegisteredSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your order has been registered!'**
  String get orderRegisteredSuccess;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @noOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrders;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrder;

  /// No description provided for @cancelOrderConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this order?'**
  String get cancelOrderConfirm;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get statusProcessing;

  /// No description provided for @statusShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get statusShipped;

  /// No description provided for @statusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get statusDelivered;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @selectQuantity.
  ///
  /// In en, this message translates to:
  /// **'Please select a quantity first'**
  String get selectQuantity;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @orderUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your order has been updated!'**
  String get orderUpdatedSuccess;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @noNotificationsMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up! We\'ll notify you when something happens.'**
  String get noNotificationsMessage;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'We\'d love your feedback'**
  String get feedbackTitle;

  /// No description provided for @feedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us what you think about our service. Your feedback helps us improve.'**
  String get feedbackSubtitle;

  /// No description provided for @yourFeedback.
  ///
  /// In en, this message translates to:
  /// **'Your feedback'**
  String get yourFeedback;

  /// No description provided for @feedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Write your feedback here...'**
  String get feedbackHint;

  /// No description provided for @feedbackRequired.
  ///
  /// In en, this message translates to:
  /// **'Please write your feedback'**
  String get feedbackRequired;

  /// No description provided for @submitFeedback.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get submitFeedback;

  /// No description provided for @feedbackSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get feedbackSuccess;

  /// No description provided for @removeItem.
  ///
  /// In en, this message translates to:
  /// **'Remove Item'**
  String get removeItem;

  /// No description provided for @removeItemConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this item from your cart?'**
  String get removeItemConfirm;

  /// No description provided for @orderInfo.
  ///
  /// In en, this message translates to:
  /// **'Order Info'**
  String get orderInfo;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @unitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get unitPrice;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @storeContacts.
  ///
  /// In en, this message translates to:
  /// **'Store Contacts'**
  String get storeContacts;

  /// No description provided for @developerContacts.
  ///
  /// In en, this message translates to:
  /// **'Developer Contacts'**
  String get developerContacts;

  /// No description provided for @callUs.
  ///
  /// In en, this message translates to:
  /// **'Call Us'**
  String get callUs;

  /// No description provided for @followUs.
  ///
  /// In en, this message translates to:
  /// **'Follow Us'**
  String get followUs;

  /// No description provided for @notification_title_order_update.
  ///
  /// In en, this message translates to:
  /// **'Order Updated'**
  String get notification_title_order_update;

  /// No description provided for @notification_message_order_update.
  ///
  /// In en, this message translates to:
  /// **'Your order has been updated by the admin. New total: {totalAmount} DZD.'**
  String notification_message_order_update(String totalAmount);

  /// No description provided for @notification_title_order_status.
  ///
  /// In en, this message translates to:
  /// **'Order Status Updated'**
  String get notification_title_order_status;

  /// No description provided for @notification_message_order_status.
  ///
  /// In en, this message translates to:
  /// **'Your order status has changed from {oldStatus} to {status}.'**
  String notification_message_order_status(String oldStatus, String status);

  /// No description provided for @newNotification.
  ///
  /// In en, this message translates to:
  /// **'You have a new notification'**
  String get newNotification;

  /// No description provided for @newNotificationsCount.
  ///
  /// In en, this message translates to:
  /// **'You have {count} new notifications'**
  String newNotificationsCount(int count);

  /// No description provided for @pendingApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Pending Approval'**
  String get pendingApprovalTitle;

  /// No description provided for @pendingApprovalMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account has been created successfully.\nPlease wait for the admin to activate your account before you can start using the app.'**
  String get pendingApprovalMessage;

  /// No description provided for @checkStatus.
  ///
  /// In en, this message translates to:
  /// **'Check Status'**
  String get checkStatus;

  /// No description provided for @orderCommentTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Comment'**
  String get orderCommentTitle;

  /// No description provided for @orderCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your comment here...'**
  String get orderCommentHint;

  /// No description provided for @addOrderComment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment to your order'**
  String get addOrderComment;

  /// No description provided for @error_invalid_credentials.
  ///
  /// In en, this message translates to:
  /// **'Username and password do not match'**
  String get error_invalid_credentials;

  /// No description provided for @error_product_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Product is currently unavailable'**
  String get error_product_unavailable;

  /// No description provided for @error_generic.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again later.'**
  String get error_generic;

  /// No description provided for @failedToLoadSettings.
  ///
  /// In en, this message translates to:
  /// **'Failed to load settings'**
  String get failedToLoadSettings;

  /// No description provided for @failedToParseSettings.
  ///
  /// In en, this message translates to:
  /// **'Failed to parse settings'**
  String get failedToParseSettings;

  /// No description provided for @weAreHereToHelp.
  ///
  /// In en, this message translates to:
  /// **'We are always here to help you.'**
  String get weAreHereToHelp;

  /// No description provided for @storeLocation.
  ///
  /// In en, this message translates to:
  /// **'Store Location'**
  String get storeLocation;

  /// No description provided for @developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed by'**
  String get developedBy;

  /// No description provided for @linkedinProfile.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn Profile'**
  String get linkedinProfile;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @linkedin.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get linkedin;

  /// No description provided for @github.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get github;

  /// No description provided for @err_username_required.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get err_username_required;

  /// No description provided for @err_username_length.
  ///
  /// In en, this message translates to:
  /// **'Username must be between 3 and 30 characters'**
  String get err_username_length;

  /// No description provided for @err_username_chars.
  ///
  /// In en, this message translates to:
  /// **'Username can only contain letters, numbers, underscores, and dots'**
  String get err_username_chars;

  /// No description provided for @err_password_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get err_password_required;

  /// No description provided for @err_password_length.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get err_password_length;

  /// No description provided for @err_password_max_length.
  ///
  /// In en, this message translates to:
  /// **'Password must not exceed 128 characters'**
  String get err_password_max_length;

  /// No description provided for @err_password_upper.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get err_password_upper;

  /// No description provided for @err_password_lower.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get err_password_lower;

  /// No description provided for @err_password_digit.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one digit'**
  String get err_password_digit;

  /// No description provided for @err_phone_format.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 8-15 digits, optionally starting with +'**
  String get err_phone_format;

  /// No description provided for @err_address_length.
  ///
  /// In en, this message translates to:
  /// **'Address must not exceed 200 characters'**
  String get err_address_length;

  /// No description provided for @err_username_in_use.
  ///
  /// In en, this message translates to:
  /// **'That username is already in use'**
  String get err_username_in_use;

  /// No description provided for @err_order_items_required.
  ///
  /// In en, this message translates to:
  /// **'Order items are required'**
  String get err_order_items_required;

  /// No description provided for @err_order_not_found.
  ///
  /// In en, this message translates to:
  /// **'Order not found'**
  String get err_order_not_found;

  /// No description provided for @err_order_cannot_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cannot cancel order in current status'**
  String get err_order_cannot_cancel;

  /// No description provided for @err_order_cancel_own.
  ///
  /// In en, this message translates to:
  /// **'You can only cancel your own orders'**
  String get err_order_cancel_own;

  /// No description provided for @err_user_not_found.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get err_user_not_found;

  /// No description provided for @err_invalid_token.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired session. Please log in again.'**
  String get err_invalid_token;

  /// No description provided for @err_already_in_use.
  ///
  /// In en, this message translates to:
  /// **'This is already in use'**
  String get err_already_in_use;

  /// No description provided for @err_no_valid_fields.
  ///
  /// In en, this message translates to:
  /// **'No valid fields to update'**
  String get err_no_valid_fields;

  /// No description provided for @err_min_amount_prefix.
  ///
  /// In en, this message translates to:
  /// **'Minimum order amount is '**
  String get err_min_amount_prefix;

  /// No description provided for @err_product_not_found.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get err_product_not_found;

  /// No description provided for @err_category_not_found.
  ///
  /// In en, this message translates to:
  /// **'Category not found'**
  String get err_category_not_found;

  /// No description provided for @err_brand_not_found.
  ///
  /// In en, this message translates to:
  /// **'Brand not found'**
  String get err_brand_not_found;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
