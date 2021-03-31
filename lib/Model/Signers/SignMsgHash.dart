import 'dart:convert';

class SignMsgHash {
  final String msgHash;
  final String arrayifyHash;
  SignMsgHash({
    required this.msgHash,
    required this.arrayifyHash,
  });

  SignMsgHash copyWith({
    String? msgHash,
    String? arrayifyHash,
  }) {
    return SignMsgHash(
      msgHash: msgHash ?? this.msgHash,
      arrayifyHash: arrayifyHash ?? this.arrayifyHash,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'msgHash': msgHash,
      'arrayifyHash': arrayifyHash,
    };
  }

  factory SignMsgHash.fromMap(Map<String, dynamic> map) {
    return SignMsgHash(
      msgHash: map['msgHash'],
      arrayifyHash: map['arrayifyHash'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SignMsgHash.fromJson(String source) =>
      SignMsgHash.fromMap(json.decode(source));

  @override
  String toString() =>
      'SignMsgHash(msgHash: $msgHash, arrayifyHash: $arrayifyHash)';
}
