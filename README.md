# Aplicație mobilă pentru rutare TransitTM

Link github: https://github.com/Andra2809/TransTim

I. Introducere - Pregătirea mediului de dezvoltare

Pentru început, trebuie să fie instalate pe calculator următoarele:

- Flutter SDK (version 3.19.5)
- Dart SDK (version 3.3.3)
- Android Studio HedgeHog (2023.1.1)

Apoi, Flutter și Dart SDK trebuie adăugate în system PATH.

II. Instalare

Urmați acești pași după clonarea locală a proiectului, pentru a configura mediul de dezvoltare:

- Porniți Android Studio cu drepturi de administrator și importați proiectul în mediul de dezvoltare Android Studio (Open -> selectați calea cu folderul proiectului)
- Navigați la directorul rădăcină al proiectului (transtim/transtim_admin sau transtim/transtim_user, în funcție de care aplicație doriți) și rulați în terminal, pentru a obține dependențele Flutter, comanda: flutter pub get

În această etapă se vor descărca și instala toate bibliotecile Flutter necesare specificate în fișierul pubspec.yaml.

III. Construirea fișierului APK și rularea aplicației pe telefonul Android

Pentru a construi fișierul APK pentru aplicația dvs. Flutter, urmați acești pași:
- Navigați în directorul proiectului dorit în terminal (cd .\trans_tim\transtim_admin\ sau  cd .\transtim\transtim_user)
- Folosiți comandă: flutter build apk
Fișierul APK va fi generat în directorul build/app/outputs/flutter-apk.
- Instalați APK-ul pe dispozitivul Android conectat la calculator, folosind comanda: flutter install
- Iconița aplicației va apărea pe telefon și aplicația va putea fi accesată

Pentru Emulator Android:
- Deschideți Android Studio, mergeți la AVD Manager și porniți un Dispozitiv Virtual Android cu minim Android 13 ca sistem de operare.
- Rulați aplicația cu comanda: flutter run
Această comandă va compila aplicația și o va lansa pe emulatorul conectat.

IV. Testarea funcționalităților

Pentru testarea funcționalităților suplimentare ale aplicației TransitTM, este necesară crearea unui cont nou de utilizator. Pentru accesarea aplicației destinată administratorilor, se vor folosi creditentialele:
Email: admin@gmail.com
Password: admin
Pentru accesarea funcționalităților suplimentare din aplicația TransitTM, se poate folosi și contul de test:
Email: utilizator@gmail.com
Password: utilizator1

IV. Resurse suplimentare:
- Documentația Flutter (https://docs.flutter.dev/)
- Documentația Dart (https://dart.dev/guides)
- Documentația pentru dezvoltare Android (https://developer.android.com/guide)
