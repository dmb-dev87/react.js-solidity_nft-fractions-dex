// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";

interface INftFractionsRepository is IERC1155Upgradeable {

  function burn(uint256 tokenId, uint256 amount, address transferer) external;

  function mint(address erc721ContractAddress, uint256 erc721TokenId, uint256 erc1155TokenId, uint256 erc1155Amount, uint256 totalFractionsAmount, address transferer, string memory tokenURI) external;

  function transferFrom(address from, address to, uint256 id, uint256 amount, bytes memory data) external;

  function getTotalFractionsAmount(uint256 _tokenId) external returns (uint256);

  function getErc721ContractAddress(uint256 _tokenId) external returns (address);
}