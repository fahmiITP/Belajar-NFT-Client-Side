import 'dart:convert';

class SetApprovalForAllModel {
  /// EIP712Domain Types
  final List<Map<String, String>> domainTypes = [
    {"name": "name", "type": "string"},
    {"name": "version", "type": "string"},
    {"name": "chainId", "type": "uint256"},
    {"name": "verifyingContract", "type": "address"}
  ];

  /// Domain Data
  final SignerDomain domainData;

  /// Message Data
  final SignerMessage messageData;

  SetApprovalForAllModel({
    required this.domainData,
    required this.messageData,
  });

  SetApprovalForAllModel copyWith({
    SignerDomain? domainData,
    SignerMessage? messageData,
  }) {
    return SetApprovalForAllModel(
      domainData: domainData ?? this.domainData,
      messageData: messageData ?? this.messageData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'domain': domainData.toMap(),
      'message': messageData.toMap(),
      'types': {"EIP712Domain": domainTypes},
    };
  }

  factory SetApprovalForAllModel.fromMap(Map<String, dynamic> map) {
    return SetApprovalForAllModel(
      domainData: SignerDomain.fromMap(map['domainData']),
      messageData: SignerMessage.fromMap(map['messageData']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SetApprovalForAllModel.fromJson(String source) =>
      SetApprovalForAllModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'SetApprovalForAllModel(domainData: $domainData, messageData: $messageData)';
}

/// Message Model
class SignerMessage {
  final String sellerAddress;
  final String originalContractAddress;
  final double price;
  final String tradeMarketAddress;
  SignerMessage({
    required this.sellerAddress,
    required this.originalContractAddress,
    required this.price,
    required this.tradeMarketAddress,
  });

  SignerMessage copyWith({
    String? sellerAddress,
    String? originalContractAddress,
    double? price,
    String? tradeMarketAddress,
  }) {
    return SignerMessage(
      sellerAddress: sellerAddress ?? this.sellerAddress,
      originalContractAddress:
          originalContractAddress ?? this.originalContractAddress,
      price: price ?? this.price,
      tradeMarketAddress: tradeMarketAddress ?? this.tradeMarketAddress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sellerAddress': sellerAddress,
      'originalContractAddress': originalContractAddress,
      'price': price,
      'tradeMarketAddress': tradeMarketAddress,
    };
  }

  factory SignerMessage.fromMap(Map<String, dynamic> map) {
    return SignerMessage(
      sellerAddress: map['sellerAddress'],
      originalContractAddress: map['originalContractAddress'],
      price: map['price'],
      tradeMarketAddress: map['tradeMarketAddress'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SignerMessage.fromJson(String source) =>
      SignerMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SignerMessage(sellerAddress: $sellerAddress, originalContractAddress: $originalContractAddress, price: $price, tradeMarketAddress: $tradeMarketAddress)';
  }
}

/// Domain Model
class SignerDomain {
  final int chainId;
  final String name;
  final String verifiyingContract;
  final String version;
  SignerDomain({
    required this.chainId,
    required this.name,
    required this.verifiyingContract,
    required this.version,
  });

  SignerDomain copyWith({
    int? chainId,
    String? name,
    String? verifiyingContract,
    String? version,
  }) {
    return SignerDomain(
      chainId: chainId ?? this.chainId,
      name: name ?? this.name,
      verifiyingContract: verifiyingContract ?? this.verifiyingContract,
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chainId': chainId,
      'name': name,
      'verifiyingContract': verifiyingContract,
      'version': version,
    };
  }

  factory SignerDomain.fromMap(Map<String, dynamic> map) {
    return SignerDomain(
      chainId: map['chainId'],
      name: map['name'],
      verifiyingContract: map['verifiyingContract'],
      version: map['version'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SignerDomain.fromJson(String source) =>
      SignerDomain.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SignerDomain(chainId: $chainId, name: $name, verifiyingContract: $verifiyingContract, version: $version)';
  }
}
