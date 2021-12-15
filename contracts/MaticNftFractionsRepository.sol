// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "./NftFractionsRepositoryBase.sol";

contract MaticNftFractionsRepository is NftFractionsRepositoryBase {
  
  using CountersUpgradeable for CountersUpgradeable.Counter;

  event DepositNft(uint256 erc1155TokenId, address erc721ContractAddress, uint256 erc721TokenId, uint256 totalFractionsAmount, string tokenURI);

  event WithdrawNft(uint256 erc1155TokenId, address erc721ContractAddress, uint256 erc721TokenId);

  CountersUpgradeable.Counter private _ids;

  function initialize(string memory uri_) public initializer {
    __NftFractionsRepositoryBase_init(uri_);
  }

  function depositNft(address erc721ContractAddress, uint256 erc721TokenId, uint256 fractionsAmountToMint) external {
    require(!paused(), "Not allowed while paused");
    ERC721URIStorage erc721Contract = ERC721URIStorage(erc721ContractAddress);
    require(erc721Contract.ownerOf(erc721TokenId) == msg.sender, "msg sender has to own the token to deposit");
    erc721Contract.transferFrom(msg.sender, address(this), erc721TokenId);
    _ids.increment();
    uint256 newItemId = _ids.current();
    _mint(msg.sender, newItemId, fractionsAmountToMint, "");
    string memory tokenURI;
    tokenURI = erc721Contract.tokenURI(erc721TokenId);
    Token memory token;
    token.erc721ContractAddress = erc721ContractAddress;
    token.erc721TokenId = erc721TokenId;
    token.totalFractionsAmount = fractionsAmountToMint;
    token.tokenURI = tokenURI;
    tokens[newItemId] = token;

    emit DepositNft(newItemId, erc721ContractAddress, erc721TokenId, fractionsAmountToMint, tokenURI);
  }

  function withdrawNft(uint256 tokenId) external {
    require(!paused(), "Not allowed while paused");
    uint256 totalFractionsAmount = tokens[tokenId].totalFractionsAmount;
    uint256 sendersAmount = balanceOf(msg.sender, tokenId);
    require(totalFractionsAmount == sendersAmount, "message sender has to own all of the shares");

    address erc721ContractAddress = tokens[tokenId].erc721ContractAddress;
    uint256 erc721TokenId = tokens[tokenId].erc721TokenId;
    IERC721 erc721Contract = IERC721(erc721ContractAddress);
    erc721Contract.transferFrom(address(this), msg.sender, erc721TokenId);

    _burn(msg.sender, tokenId, totalFractionsAmount);

    delete tokens[tokenId];

    emit WithdrawNft(tokenId, erc721ContractAddress, erc721TokenId);
  }
}