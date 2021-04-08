import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:tuple/tuple.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:web3front/Global/FlutterKey.dart';

class CryptoAESHelper {
  final _passphrase = FlutterKey.rawkey;

  /// Encrypt to AES like Crypto JS
  String encryptAESCryptoJS(String plainText) {
    try {
      final salt = genRandomWithNonZero(8);
      var keyndIV = deriveKeyAndIV(_passphrase, salt);
      final key = encrypt.Key(keyndIV.item1);
      final iv = encrypt.IV(keyndIV.item2);

      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      Uint8List encryptedBytesWithSalt = Uint8List.fromList(
          createUint8ListFromString("Salted__") + salt + encrypted.bytes);
      return base64.encode(encryptedBytesWithSalt);
    } catch (error) {
      throw error;
    }
  }

  /// Decrypt from AES to plain String like Crypto JS
  String decryptAESCryptoJS(String encrypted) {
    try {
      Uint8List encryptedBytesWithSalt = base64.decode(encrypted);

      Uint8List encryptedBytes =
          encryptedBytesWithSalt.sublist(16, encryptedBytesWithSalt.length);
      final salt = encryptedBytesWithSalt.sublist(8, 16);
      var keyndIV = deriveKeyAndIV(_passphrase, salt);
      final key = encrypt.Key(keyndIV.item1);
      final iv = encrypt.IV(keyndIV.item2);

      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
      final decrypted =
          encrypter.decrypt64(base64.encode(encryptedBytes), iv: iv);
      return decrypted;
    } catch (error) {
      throw error;
    }
  }

  /// I don't know how these code works, i copied it from : https://gist.github.com/suehok/dfc4a6989537e4a3ba4058669289737f
  Tuple2<Uint8List, Uint8List> deriveKeyAndIV(
      String passphrase, Uint8List salt) {
    var password = createUint8ListFromString(passphrase);
    Uint8List concatenatedHashes = Uint8List(0);
    Uint8List currentHash = Uint8List(0);
    bool enoughBytesForKey = false;
    Uint8List preHash = Uint8List(0);

    while (!enoughBytesForKey) {
      if (currentHash.length > 0)
        preHash = Uint8List.fromList(currentHash + password + salt);
      else
        preHash = Uint8List.fromList(password + salt);

      currentHash = Uint8List.fromList(md5.convert(preHash).bytes);
      concatenatedHashes = Uint8List.fromList(concatenatedHashes + currentHash);
      if (concatenatedHashes.length >= 48) enoughBytesForKey = true;
    }

    var keyBtyes = concatenatedHashes.sublist(0, 32);
    var ivBtyes = concatenatedHashes.sublist(32, 48);
    return new Tuple2(keyBtyes, ivBtyes);
  }

  Uint8List createUint8ListFromString(String s) {
    var ret = new Uint8List(s.length);
    for (var i = 0; i < s.length; i++) {
      ret[i] = s.codeUnitAt(i);
    }
    return ret;
  }

  Uint8List genRandomWithNonZero(int seedLength) {
    final random = Random.secure();
    const int randomMax = 245;
    final Uint8List uint8list = Uint8List(seedLength);
    for (int i = 0; i < seedLength; i++) {
      uint8list[i] = random.nextInt(randomMax) + 1;
    }
    return uint8list;
  }
}
