class OnboardingModel {
  final String imagePath;
  final String skipText;
  final String title;
  final String? subtitle; 

  OnboardingModel({
    required this.imagePath,
    required this.skipText,
    required this.title,
    this.subtitle, // 
  });
}