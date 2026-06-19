// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Application E-Commerce';

  @override
  String get profile => 'Profil';

  @override
  String get guest => 'Invité';

  @override
  String get profileInformation => 'Informations du profil';

  @override
  String get notification => 'Notification';

  @override
  String get ordersHistory => 'Historique des commandes';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get contactUs => 'Nous contacter';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get notLoggedIn => 'Non connecté';

  @override
  String get personalInformation => 'Informations personnelles';

  @override
  String get name => 'Nom';

  @override
  String get phone => 'Téléphone';

  @override
  String get address => 'Adresse';

  @override
  String get notSet => 'Non défini';

  @override
  String get edit => 'Modifier';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get password => 'Mot de passe';

  @override
  String get editPassword => 'Modifier le mot de passe';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get save => 'Enregistrer';

  @override
  String get passwordReset => 'Réinitialisation du mot de passe';

  @override
  String get oldPassword => 'Ancien mot de passe';

  @override
  String get requiredField => 'Requis';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get atLeast6Chars => 'Au moins 6 caractères';

  @override
  String get newPasswordConfirmation => 'Confirmation du nouveau mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get passwordUpdated => 'Mot de passe mis à jour avec succès';

  @override
  String get system => 'Système';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get home => 'Accueil';

  @override
  String get search => 'Recherche';

  @override
  String get cart => 'Panier';

  @override
  String get categories => 'Catégories';

  @override
  String get logIn => 'Se connecter';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get dontHaveAccount => 'vous n\'avez pas encore de compte';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ?';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get deliveryAddress => 'Adresse de livraison';

  @override
  String get orText => 'ou';

  @override
  String get selectLocationOnMap =>
      'Sélectionner l\'emplacement exact sur la carte';

  @override
  String get locationSelected => '📍 Emplacement sélectionné';

  @override
  String get pleaseProvideAddress =>
      'Veuillez fournir une adresse ou sélectionner un emplacement sur la carte';

  @override
  String get selectLocation => 'Sélectionner l\'emplacement';

  @override
  String get detectingLocation => 'Détection de votre emplacement...';

  @override
  String get tapMapToSelect =>
      'Appuyez sur la carte pour sélectionner votre emplacement';

  @override
  String get selectedLocation => 'Emplacement sélectionné';

  @override
  String get confirmLocation => 'Confirmer l\'emplacement';

  @override
  String get usernameRequired => 'Le nom d\'utilisateur est requis';

  @override
  String get usernameMinLength =>
      'Le nom d\'utilisateur doit comporter au moins 3 caractères';

  @override
  String get passwordRequired => 'Le mot de passe est requis';

  @override
  String get passwordMinLength =>
      'Le mot de passe doit comporter au moins 6 caractères';

  @override
  String get phoneRequired => 'Le numéro de téléphone est requis';

  @override
  String get phoneInvalid =>
      'Le téléphone doit commencer par 05, 06 ou 07 (10 chiffres)';

  @override
  String get addressRequired => 'L\'adresse est requise';

  @override
  String get loginFailed => 'Échec de la connexion. Veuillez réessayer.';

  @override
  String get registrationFailed =>
      'Échec de l\'inscription. Veuillez réessayer.';

  @override
  String get profileUpdateFailed => 'Échec de la mise à jour du profil.';

  @override
  String get registrationSuccess =>
      'Inscription réussie ! Veuillez vous connecter.';

  @override
  String get location => 'Emplacement';

  @override
  String get changeLocation => 'Changer l\'emplacement';

  @override
  String get locationNotSet => 'Emplacement non défini';

  @override
  String get locationSet => 'Emplacement défini';

  @override
  String get storeName => 'Grocist Medber';

  @override
  String get welcomeBack => 'Bienvenue !';

  @override
  String get newProducts => 'Nouveautés';

  @override
  String get popular => 'Populaire';

  @override
  String get viewMore => 'Voir plus';

  @override
  String get failedToLoadData => 'Échec du chargement des données.';

  @override
  String get currency => 'DA';

  @override
  String get brands => 'Marques';

  @override
  String get boxes => 'Boîtes';

  @override
  String get units => 'Unités';

  @override
  String get addToCart => 'Ajouter au panier';

  @override
  String boxContainsUnits(int count) {
    return '1 Boîte = $count unité(s)';
  }

  @override
  String get reset => 'Réinitialiser';

  @override
  String get priceRange => 'Gamme de prix';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get apply => 'Appliquer';

  @override
  String get retry => 'Réessayer';

  @override
  String get noResults => 'Aucun résultat trouvé';

  @override
  String get newestProducts => 'Nouveaux produits';

  @override
  String get bestSelling => 'Meilleures ventes';

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
}
