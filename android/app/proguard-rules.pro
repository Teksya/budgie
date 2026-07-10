# ML Kit text recognition ships only the Latin model here; the plugin still
# references the Chinese/Devanagari/Japanese/Korean recognizers, which R8 can't
# find. We don't use them, so silence the warnings and keep the ML Kit classes.
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
