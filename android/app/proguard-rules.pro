# Flutter Local Notifications ProGuard rules
-keep class com.dexterous.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Play Core library rules
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Firebase rules
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Google Sign-In rules
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }

# GSON rules
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# Keep notification models
-keep class com.dexterous.flutterlocalnotifications.models.** { *; }

# Keep Flutter embedding classes
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Keep reflection-based classes
-keepattributes InnerClasses
-keepattributes EnclosingMethod
