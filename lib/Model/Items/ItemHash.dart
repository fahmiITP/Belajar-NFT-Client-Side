import 'dart:convert';

class ItemHash {
  ItemHash({
    this.msgHash,
    this.signature,
  });

  final String? msgHash;
  final String? signature;

  ItemHash copyWith({
    String? msgHash,
    String? signature,
  }) =>
      ItemHash(
        msgHash: msgHash ?? this.msgHash,
        signature: signature ?? this.signature,
      );

  factory ItemHash.fromRawJson(String str) =>
      ItemHash.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemHash.fromJson(Map<String, dynamic> json) => ItemHash(
        msgHash: json["msg_hash"] == null ? null : json["msg_hash"],
        signature: json["signature"] == null ? null : json["signature"],
      );

  Map<String, dynamic> toJson() => {
        "msg_hash": msgHash == null ? null : msgHash,
        "signature": signature == null ? null : signature,
      };
}
