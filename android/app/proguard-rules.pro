# Flutter default rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Freezed
-keep class ** { *; }
-keepclassmembers class ** {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Drift
-keep class drift.** { *; }
-keep class * extends drift.Database { *; }
-keep class * extends androidx.sqlite.db.SupportSQLiteOpenHelper { *; }

# Riverpod
-keep class riverpod.** { *; }

# GoRouter
-keep class go_router.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable
-keepnames class * implements java.io.Serializable
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Remove logging in release
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
}

# Google Play Core Library
# These classes are referenced by Flutter's PlayStoreSplitApplication but are optional
# for deferred components loading. They are not needed at runtime for standard builds.
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# OkHttp (referenced by Firebase/Play Services)
-keep class com.squareup.okhttp.** { *; }
-keep interface com.squareup.okhttp.** { *; }
-dontwarn com.squareup.okhttp.**

# gRPC OkHttp
-keep class io.grpc.okhttp.** { *; }
-keep interface io.grpc.okhttp.** { *; }
-dontwarn io.grpc.okhttp.**

# Guava (referenced by Play Services)
-keep class com.google.common.** { *; }
-keep interface com.google.common.** { *; }
-dontwarn com.google.common.**

# Keep Java reflection classes
-keep class java.lang.reflect.** { *; }
