class ChainIDConverter {
  static convertToString({required String chainIdHex}) {
    switch (chainIdHex) {
      case "0x1":
        return "Mainnet";
      case "0x3":
        return "Ropsten";
      case "0x4":
        return "Rinkeby";
      case "0x5":
        return "Goerli";
      case "0x2a":
        return "Kovan";
      default:
        return "Custom Net";
    }
  }
}
