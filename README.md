# Caja de herramientas (multitool_app)

Aplicación Flutter con varias utilidades en una sola app. Proyecto académico.

## Funcionalidades

| Vista | Descripción | API |
|---|---|---|
| Inicio | Imagen de caja de herramientas y menú de acceso | N/A |
| Predecir género | Predice el género por nombre; azul si es masculino, rosa si es femenino | [Genderize.io](https://api.genderize.io/) |
| Persona aleatoria | Nombre, apellido, foto, fecha de nacimiento y edad | [RandomUser](https://randomuser.me/api/) |
| Universidades por país | Nombre, dominio y enlace web de cada universidad (país en inglés) | Universities API vía proxy de adamix.net |
| Clima en RD | Pronóstico del día en República Dominicana | [API de clima usada] |
| Pokémon | Foto, experiencia base, habilidades y sonido | [PokéAPI](https://pokeapi.co/) |
| Noticias | Logo del sitio y últimas 3 noticias con enlace "Visitar" | WordPress REST API de [sitio usado] |
| Acerca de | Foto y datos de contacto | N/A |

## Requisitos

- Flutter [versión, ej. 3.47.x] y Dart SDK
- Android Studio con un emulador, o un dispositivo Android

## Ejecución

```bash
git clone https://github.com/TU_USUARIO/multitool_app.git
cd multitool_app
flutter pub get
flutter run
```

## Pruebas

```bash
flutter test
```

## Generar el APK

```bash
flutter build apk --release
```

El archivo queda en `build/app/outputs/flutter-apk/app-release.apk`.

## Autor

Ana Z. Santana G. — Matrícula 20242153
