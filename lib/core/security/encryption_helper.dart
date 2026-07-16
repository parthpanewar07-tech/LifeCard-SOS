import 'dart:convert';
import 'package:crypto/crypto.dart';

class EncryptionHelper {
  EncryptionHelper._();

  /// Encrypts a plaintext string using a key stretched from a password using SHA-256.
  static String encrypt(String plainText, String password) {
    final keyBytes = sha256.convert(utf8.encode(password)).bytes;
    final plainBytes = utf8.encode(plainText);
    final cipherBytes = List<int>.filled(plainBytes.length, 0);

    for (int i = 0; i < plainBytes.length; i++) {
      // XOR stream cipher with SHA-256 password bytes
      cipherBytes[i] = plainBytes[i] ^ keyBytes[i % keyBytes.length];
    }

    return base64UrlEncode(cipherBytes);
  }

  /// Decrypts a ciphertext string using a key stretched from a password using SHA-256.
  static String decrypt(String cipherText, String password) {
    final keyBytes = sha256.convert(utf8.encode(password)).bytes;
    final cipherBytes = base64Url.decode(cipherText);
    final plainBytes = List<int>.filled(cipherBytes.length, 0);

    for (int i = 0; i < cipherBytes.length; i++) {
      plainBytes[i] = cipherBytes[i] ^ keyBytes[i % keyBytes.length];
    }

    return utf8.decode(plainBytes);
  }
}
