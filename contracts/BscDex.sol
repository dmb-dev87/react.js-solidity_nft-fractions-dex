// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./DexBase.sol";

contract BscDex is DexBase {
  function initialize() public initializer {
    __DexBase_init();
  }

  function getOrders(uint256 tokenId, Side side) external view returns (Order[] memory) {
    return orderBook[tokenId][uint256(side)];
  }

  function getEthBalance(address owner) public view returns (uint256) {
    return ethBalance[owner];
  }

  function getEthReserveBalance(address owner) public view returns (uint256) {
    return ethReservedBalance[owner];
  }

  function getSharesReserveBalance(address owner, uint256 tokenId) public view returns (uint256) {
    return sharesReserved[owner][tokenId];
  }
}