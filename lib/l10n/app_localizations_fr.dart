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
  String get cartItems => 'Articles du panier';

  @override
  String get removeAll => 'Tout supprimer';

  @override
  String get clearCartConfirm =>
      'Êtes-vous sûr de vouloir supprimer tous les articles de votre panier ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get productsTotal => 'Total des produits';

  @override
  String get delivery => 'Livraison';

  @override
  String get total => 'Total';

  @override
  String get placeOrder => 'Passer la commande';

  @override
  String get updateOrder => 'Mettre à jour la commande';

  @override
  String get cartEmpty => 'Votre panier est vide';

  @override
  String get cartEmptyMessage =>
      'Parcourez les produits et ajoutez des articles à votre panier pour commencer.';

  @override
  String get addedToCart => 'Ajouté au panier !';

  @override
  String get pleaseWaitOrderRegistered =>
      'Veuillez patienter pendant l\'enregistrement de votre commande';

  @override
  String get orderRegisteredSuccess => 'Votre commande a été enregistrée !';

  @override
  String get order => 'Commande';

  @override
  String get noOrders => 'Pas encore de commandes';

  @override
  String get cancelOrder => 'Annuler la commande';

  @override
  String get cancelOrderConfirm =>
      'Êtes-vous sûr de vouloir annuler cette commande ?';

  @override
  String get pleaseWait => 'Veuillez patienter...';

  @override
  String get statusPending => 'En attente';

  @override
  String get statusProcessing => 'En traitement';

  @override
  String get statusShipped => 'Expédié';

  @override
  String get statusDelivered => 'Livré';

  @override
  String get statusCancelled => 'Annulé';

  @override
  String get selectQuantity => 'Veuillez d\'abord sélectionner une quantité';

  @override
  String get products => 'Produits';

  @override
  String get orderUpdatedSuccess => 'Votre commande a été mise à jour !';

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
}
