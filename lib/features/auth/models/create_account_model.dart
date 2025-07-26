class CreateAccountModel {
  final String splashIcon;
  final String emailIcon;
  final String passwordIcon;
  final String eyeIcon;

  final String title;
  final String subtitle;
  final String usernameLabel;
  final String emailLabel;
  final String passwordLabel;
  final String confirmPasswordLabel;
  final String alreadyHaveAccount;
  final String signInText;

  CreateAccountModel({
    required this.splashIcon,
    required this.emailIcon,
    required this.passwordIcon,
    required this.eyeIcon,
    required this.title,
    required this.subtitle,
    required this.usernameLabel,
    required this.emailLabel,
    required this.passwordLabel,
    required this.confirmPasswordLabel,
    required this.alreadyHaveAccount,
    required this.signInText,
  });
}