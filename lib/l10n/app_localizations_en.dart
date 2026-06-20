// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'E-Commerce App';

  @override
  String get profile => 'Profile';

  @override
  String get guest => 'Guest';

  @override
  String get profileInformation => 'Profile information';

  @override
  String get notification => 'Notification';

  @override
  String get ordersHistory => 'Orders history';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get contactUs => 'Contact us';

  @override
  String get logOut => 'Log out';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get notLoggedIn => 'Not logged in';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get address => 'Address';

  @override
  String get notSet => 'Not set';

  @override
  String get edit => 'Edit';

  @override
  String get privacy => 'Privacy';

  @override
  String get password => 'Password';

  @override
  String get editPassword => 'Edit Password';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get save => 'Save';

  @override
  String get passwordReset => 'Password Reset';

  @override
  String get oldPassword => 'Old password';

  @override
  String get requiredField => 'Required';

  @override
  String get newPassword => 'New password';

  @override
  String get atLeast6Chars => 'At least 6 characters';

  @override
  String get newPasswordConfirmation => 'New password confirmation';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordUpdated => 'Password updated successfully';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get home => 'Home';

  @override
  String get search => 'Search';

  @override
  String get cart => 'Cart';

  @override
  String get categories => 'Categories';

  @override
  String get logIn => 'Log in';

  @override
  String get signUp => 'Sign up';

  @override
  String get username => 'Username';

  @override
  String get dontHaveAccount => 'you don\'t have an account yet';

  @override
  String get alreadyHaveAccount => 'Already have an account ?';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get deliveryAddress => 'Delivery address';

  @override
  String get orText => 'or';

  @override
  String get selectLocationOnMap => 'Select exact location on map';

  @override
  String get locationSelected => '📍 Location selected';

  @override
  String get pleaseProvideAddress =>
      'Please provide an address or select a location on the map';

  @override
  String get selectLocation => 'Select Location';

  @override
  String get detectingLocation => 'Detecting your location...';

  @override
  String get tapMapToSelect => 'Tap on the map to select your location';

  @override
  String get selectedLocation => 'Selected Location';

  @override
  String get confirmLocation => 'Confirm Location';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get usernameMinLength => 'Username must be at least 3 characters';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get phoneInvalid => 'Phone must start with 05, 06, or 07 (10 digits)';

  @override
  String get addressRequired => 'Address is required';

  @override
  String get loginFailed => 'Login failed. Please try again.';

  @override
  String get registrationFailed => 'Registration failed. Please try again.';

  @override
  String get profileUpdateFailed => 'Profile update failed.';

  @override
  String get registrationSuccess => 'Registration successful! Please log in.';

  @override
  String get location => 'Location';

  @override
  String get changeLocation => 'Change Location';

  @override
  String get locationNotSet => 'Location not set';

  @override
  String get locationSet => 'Location set';

  @override
  String get storeName => 'Grocist Medber';

  @override
  String get welcomeBack => 'Welcome Back !';

  @override
  String get newProducts => 'New';

  @override
  String get popular => 'Popular';

  @override
  String get viewMore => 'View More';

  @override
  String get failedToLoadData => 'Failed to load data.';

  @override
  String get currency => 'DA';

  @override
  String get brands => 'Brands';

  @override
  String get boxes => 'Boxes';

  @override
  String get units => 'Units';

  @override
  String get addToCart => 'Add to cart';

  @override
  String boxContainsUnits(int count) {
    return '1 Box = $count unit';
  }

  @override
  String get reset => 'Reset';

  @override
  String get priceRange => 'Price Range';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get apply => 'Apply';

  @override
  String get retry => 'Retry';

  @override
  String get noResults => 'No results found';

  @override
  String get newestProducts => 'Newest Products';

  @override
  String get bestSelling => 'Best Selling';

  @override
  String get cartItems => 'Cart items';

  @override
  String get removeAll => 'Remove All';

  @override
  String get clearCartConfirm =>
      'Are you sure you want to remove all items from your cart?';

  @override
  String get cancel => 'Cancel';

  @override
  String get productsTotal => 'Products total';

  @override
  String get delivery => 'Delivery';

  @override
  String get total => 'Total';

  @override
  String get placeOrder => 'Place Order';

  @override
  String get updateOrder => 'Update Order';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get cartEmptyMessage =>
      'Browse products and add items to your cart to get started.';

  @override
  String get addedToCart => 'Added to cart!';

  @override
  String get pleaseWaitOrderRegistered =>
      'Please wait while your order gets registered';

  @override
  String get orderRegisteredSuccess => 'Your order has been registered!';

  @override
  String get order => 'Order';

  @override
  String get noOrders => 'No orders yet';

  @override
  String get cancelOrder => 'Cancel Order';

  @override
  String get cancelOrderConfirm =>
      'Are you sure you want to cancel this order?';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusProcessing => 'Processing';

  @override
  String get statusShipped => 'Shipped';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get selectQuantity => 'Please select a quantity first';

  @override
  String get products => 'Products';

  @override
  String get orderUpdatedSuccess => 'Your order has been updated!';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get noNotificationsMessage =>
      'You\'re all caught up! We\'ll notify you when something happens.';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackTitle => 'We\'d love your feedback';

  @override
  String get feedbackSubtitle =>
      'Tell us what you think about our service. Your feedback helps us improve.';

  @override
  String get yourFeedback => 'Your feedback';

  @override
  String get feedbackHint => 'Write your feedback here...';

  @override
  String get feedbackRequired => 'Please write your feedback';

  @override
  String get submitFeedback => 'Submit Feedback';

  @override
  String get feedbackSuccess => 'Thank you for your feedback!';

  @override
  String get removeItem => 'Remove Item';

  @override
  String get removeItemConfirm =>
      'Are you sure you want to remove this item from your cart?';

  @override
  String get orderInfo => 'Order Info';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get unitPrice => 'Unit Price';

  @override
  String get comment => 'Comment';

  @override
  String get product => 'Product';

  @override
  String get quantity => 'Quantity';
}
