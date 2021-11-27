#apk
flutter clean && flutter pub get && flutter build apk --release --no-sound-null-safety

# appbundle
flutter clean && flutter pub get && flutter build appbundle --release --no-sound-null-safety

# appbundle
flutter clean && flutter pub get && flutter build appbundle --target-platform android-arm,android-arm64 --no-sound-null-safety
