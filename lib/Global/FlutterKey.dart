import 'package:encrypt/encrypt.dart' as encrypt;

class FlutterKey {
  static const String rawkey =
      "9AB594AF51502DBC4220E5DB547E85845A36FD2E3EE8E058";
  static const String rawiv = "F869A0F541AC6A074F4F11D6F82E6EA3";

  static final key = encrypt.Key.fromBase16(rawkey);
  static final iv = encrypt.IV.fromBase16(rawiv);
}
