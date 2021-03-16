# Web3front

A new Flutter project.
This project only runs on Flutter Web and with Null Safety Sound.
Make sure you have Flutter 2.0 installed on your machine.

## How to Use

- Run 'flutter pub get'
- Run flutter on chrome (flutter run -d chrome).

## How to Deploy

- Clone this repository.
- Run 'flutter pub get'
- Modify the app's API Endpoint to your server address. (lib/Global/Endpoints.dart -> apiBaseUrl).
- You can modify the App Title on (lib/main.dart -> MaterialApp -> title).
- If everything has been set up, run "flutter build web".
- The ready to deploy webapp will be on "build/web" folder.
- Pack or Compress the webapp folder.
- Upload the packed file to your 'public_html' directory on your hosting.
- Extract and move all the file inside to the root of your 'public_html'.
- You're done.
