# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Flutter deferred components (optional feature)
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Gson specific classes
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.examples.android.model.** { <fields>; }
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# Stripe
-keep class com.stripe.** { *; }
-dontwarn com.stripe.**

# Socket.IO
-keep class io.socket.** { *; }
-dontwarn io.socket.**

# Keep custom model classes
-keep class com.roxy.whisp.** { *; }

# Keep all model classes in your app
-keep class * extends java.io.Serializable { *; }

# Google Play Core (optional - for deferred components)
# These are optional dependencies that Flutter references but may not be used
# Using -dontwarn to suppress warnings about missing classes
-dontwarn com.google.android.play.core.**
# Note: We don't use -keep here since the classes may not exist
# R8 will handle missing classes gracefully with -dontwarn

# BouncyCastle (optional cryptography library - used by some JWT/crypto libraries)
-dontwarn org.bouncycastle.**
# Note: We don't use -keep here since the classes may not exist
# R8 will handle missing classes gracefully with -dontwarn

# Remove logging in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

