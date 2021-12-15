// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./INftFractionsRepository.sol";

contract NftFractionsRepositoryBase is Initializable, ERC1155Upgradeable, PausableUpgradeable, OwnableUpgradeable, INftFractionsRepository {

  struct Token {
    address erc721ContractAddress;
    uint256 erc721TokenId;
    uint256 totalFractionsAmount;
    string tokenURI;
  }

  mapping(uint256 => Token) internal tokens;

  function __NftFractionsRepositoryBase_init(string memory uri_) internal initializer {
    __Context_init_unchained();
    __ERC165_init_unchained();
    __Pausable_init_unchained();
    __ERC1155_init_unchained(uri_);
    __Ownable_init_unchained();
  }

  function burn(uint256 tokenId, uint256 amount, address transferer) external override onlyOwner() {
    require(!paused(), "Not allowed while paused");
    uint256 transfererAmount = balanceOf(transferer, tokenId);
    require(transfererAmount >= amount, "transferer has to own equal or more shares than the given amount");
    _burn(transferer, tokenId, amount);
    _afterBurn(tokenId, amount, transferer, transfererAmount);
  }

  function mint(address erc721ContractAddress, uint256 erc721TokenId, uint256 erc1155TokenId, uint256 erc1155Amount, uint256 totalFractionsAmount, address transferer, string memory tokenURI) external override onlyOwner() {
    require(!paused(), "Not allowed while paused");
    _mint(transferer, erc1155TokenId, erc1155Amount, "");

    bool existingToken = true;
    if (tokens[erc1155TokenId].erc721ContractAddress == address(0)) {
      Token memory token;
      token.erc721ContractAddress = erc721ContractAddress;
      token.erc721TokenId = erc721TokenId;
      token.totalFractionsAmount = totalFractionsAmount;
      token.tokenURI = tokenURI;
      tokens[erc1155TokenId] = token;
      existingToken = false;
    }

    _afterMint(erc1155TokenId, transferer, existingToken);
  }

  function transferFrom(address from, address to, uint256 id, uint256 amount, bytes memory data) external override {
    require(!paused(), "Not allowed while paused");
    uint256 fromBalanceBefore = balanceOf(from, id);
    uint256 toBalanceBefore = balanceOf(to, id);
    safeTransferFrom(from, to, id, amount, data);
    _afterTransferFrom(from, to, id, amount, fromBalanceBefore, toBalanceBefore);
  }

  function getTokenData(uint256 _tokenId) public view returns (address erc721ContractAddress, uint256 erc721TokenId, uint256 totalFractinsAmount, string memory tokenURL) {
    return (tokens[_tokenId].erc721ContractAddress, tokens[_tokenId].erc721TokenId, tokens[_tokenId].totalFractionsAmount, tokens[_tokenId].tokenURI);
  }

  function getTotalFractionsAmount(uint256 _tokenId) external view override returns (uint256) {
    return (tokens[_tokenId].totalFractionsAmount);
  }

  function getErc721ContractAddress(uint256 _tokenId) external view override returns (address) {
    return (tokens[_tokenId].erc721ContractAddress);
  }

  function pause() public onlyOwner() {
    _pause();
  }

  function _afterBurn(uint256 tokenId, uint256 amount, address transferer, uint256 transferersAmount) internal virtual {}

  function _afterMint(uint256 erc1155TokenId, address transferer, bool existingToken) internal virtual {}

  function _afterTransferFrom(address from, address to, uint256 id, uint256 amount, uint256 fromBalanceBefore, uint256 toBalanceBefore) internal virtual {}
}