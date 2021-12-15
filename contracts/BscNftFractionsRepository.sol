// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./NftFractionsRepositoryBase.sol";

contract BscNftFractionsRepository is NftFractionsRepositoryBase {

  mapping(address => uint256[]) tokenIdsByShareOwner;

  mapping(uint256 => address[]) ownersByTokenId;

  uint256[] tokenIds;

  function initialize(string memory uri_) public initializer {
    __NftFractionsRepositoryBase_init(uri_);
  }

  function _afterBurn(uint256 tokenId, uint256 amount, address transferer, uint256 transferersAmount) internal override {
    if (transferersAmount == amount) {
      deleteIdFromTokenIdsByShareOwner(transferer, tokenId);
      deleteOwnerFromOwnersByTokenId(transferer, tokenId);
    }
  }

  function _afterMint(uint256 erc1155TokenId, address transferer, bool existingToken) internal override {
    if (!existingToken) {
      tokenIds.push(erc1155TokenId);
    }

    uint256 nrOfTokensByTransferer = tokenIdsByShareOwner[transferer].length;

    if (nrOfTokensByTransferer == 0) {
      tokenIdsByShareOwner[transferer].push(erc1155TokenId);
    } else {
      for (uint256 i; i < nrOfTokensByTransferer; i++) {
        if (erc1155TokenId == tokenIdsByShareOwner[transferer][i]) {
          break;
        }
        if (i == nrOfTokensByTransferer - 1) {
          tokenIdsByShareOwner[transferer].push(erc1155TokenId);
        }
      }
    }

    uint256 nrOfOwnerByTokenId = ownersByTokenId[erc1155TokenId].length;
    if (nrOfOwnerByTokenId == 0) {
      ownersByTokenId[erc1155TokenId].push(transferer);
    } else {
      for (uint256 i; i < nrOfOwnerByTokenId; i++) {
        if (transferer == ownersByTokenId[erc1155TokenId][i]) {
          break;
        }
        if (i == nrOfOwnerByTokenId - 1) {
          ownersByTokenId[erc1155TokenId].push(transferer);
        }
      }
    }
  }

  function _afterTransferFrom(address from, address to, uint256 id, uint256 amount, uint256 fromBalanceBefore, uint256 toBalanceBefore) internal override {
    if (amount >= fromBalanceBefore) {
      uint256 nrOfOwners = ownersByTokenId[id].length;
      uint256 ownerPosition;
      for (uint256 i; i < nrOfOwners; i++) {
        if (from == ownersByTokenId[id][i]) {
          ownerPosition = i;
          break;
        }
      }
      ownersByTokenId[id][ownerPosition] = ownersByTokenId[id][nrOfOwners - 1];
      ownersByTokenId[id].pop();
      deleteIdFromTokenIdsByShareOwner(from, id);
    }
    if (toBalanceBefore == 0) {
      ownersByTokenId[id].push(to);
      tokenIdsByShareOwner[to].push(id);
    }
  }

  function getTokenIdsByShareOwner(address shareOwner) public view returns (uint256[] memory) {
    return tokenIdsByShareOwner[shareOwner];
  }

  function getOwnersByTokenId(uint256 tokenId) public view returns (address[] memory) {
    return ownersByTokenId[tokenId];
  }

  function getTokenIds() public view returns (uint256[] memory) {
    return tokenIds;
  }

  function deleteIdFromTokenIdsByShareOwner(address owner, uint256 id) private {
    uint256 nrOfTokensByShareOwner = tokenIdsByShareOwner[owner].length;
    uint256 tokenIdPositionInShareOwner;
    for (uint256 i; i < nrOfTokensByShareOwner; i++) {
      if (id == tokenIdsByShareOwner[owner][i]) {
        tokenIdPositionInShareOwner = i;
        break;
      }
    }

    tokenIdsByShareOwner[owner][tokenIdPositionInShareOwner] = tokenIdsByShareOwner[owner][nrOfTokensByShareOwner - 1];
    tokenIdsByShareOwner[owner].pop();
  }

  function deleteOwnerFromOwnersByTokenId(address owner, uint256 id) private {
    uint256 nrOfOwnersByTokenId = ownersByTokenId[id].length;
    uint256 ownerPositionInOwners;
    for (uint256 i; i < nrOfOwnersByTokenId; i++) {
      if (owner == ownersByTokenId[id][i]) {
        ownerPositionInOwners = i;
        break;
      }
    }
    ownersByTokenId[id][ownerPositionInOwners] = ownersByTokenId[id][nrOfOwnersByTokenId - 1];
    ownersByTokenId[id].pop();
  }
}