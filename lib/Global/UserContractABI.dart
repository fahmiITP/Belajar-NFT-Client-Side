class UserContractABI {
  static const List<String> abi = [
    "function totalToken() external view returns (uint256)",
    "function symbol() external view returns (string memory _symbol)",
    "function name() external view returns (string memory _name)",
    "function tokenURI(uint256 _tokenId) external view returns (string memory)",
    "function mint(address _to, uint256 _tokenId, string calldata _uri)",
    "function burn(uint256 _tokenId)",
    "function isApprovedForAll(address _owner, address _operator) external view returns (bool)",
    "function getApproved(uint256 _tokenId) external view returns (address)",
    "function ownerOf(uint256 _tokenId) external view returns (address)",
    "function balanceOf(address _owner) external view returns (uint256)",
    "function setApprovalForAll(address _operator, bool _approved) external",
    "function approve(address _approved, uint256 _tokenId) external",
    "function transferFrom(address _from, address _to, uint256 _tokenId) external",
    "function safeTransferFrom(address _from, address _to, uint256 _tokenId) external",
    "event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved)",
    "event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId)",
    "event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId)",
    "event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)"
  ];
}
