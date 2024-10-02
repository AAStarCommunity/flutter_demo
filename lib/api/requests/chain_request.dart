class ChainRequest {
  String? alias;
  String? network;

  ChainRequest({this.alias, this.network});

  ChainRequest.fromJson(Map<String, dynamic> json) {
    alias = json['alias'];
    network = json['network'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alias'] = this.alias;
    data['network'] = this.network;
    return data;
  }
}

enum SeedworksChain {
  ARBITRUM_NOVA,
  ARBITRUM_ONE,
  ARBITRUM_SEPOLIA,
  BASE_MAINNET,
  BASE_SEPOLIA,
  ETHEREUM_MAINNET,
  ETHEREUM_SEPOLIA,
  OPTIMISM_MAINNET,
  OPTIMISM_SEPOLIA,
  SCROLL_MAINNET,
  SCROLL_SEPOLIA,
  STARKNET_MAINNET,
  STARKNET_SEPOLIA
}

