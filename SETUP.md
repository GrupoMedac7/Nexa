1. Instalar dependencias:
flutter pub get

2. Pedidme si no los tenéis los siguientes archivos (porque no se comparten con git):
./android/app/build.gradle
./ios/Runner/GoogleService-Info.plist

3. Configurar Firebase en Flutter:
dart pub global activate flutterfire_cli
flutterfire configure (si no tenéis ./lib/firebase_options.dart)

4. Run:
flutter run

5. Flujo de trabajo (Git branches):
master -> código revisado y estable
dev -> código en desarrollo
ramas de funciones -> pull request hacia dev