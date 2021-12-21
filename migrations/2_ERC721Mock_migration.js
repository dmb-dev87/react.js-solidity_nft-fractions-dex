const ERC721Mock = artifacts.require("ERC721Mock");
const metaDataIpfsCIDs = [
  "QmTo7ePHXVyVEkd6TJd7irs5ZRBAi9UzH2VRY9tFZqEZBh",
  "QmVG1CgUVs4ZMqUgQ22AGt4YUu26TKqqLUEyWav81s5SEU",
  "QmQE3kGsvWRNjwFd1GuV2suzDocaJj7Gwh7qkb47Wg1sTM"];

module.exports = async function (deployer, network) {
  if (network === 'development' || network === 'maticMumbai') {
    await deployer.deploy(ERC721Mock);
    const erc721MockInstance = await ERC721Mock.deployed();

    const nftOwner1 = '0x04BFca9b23e8110E10C28941E9A9c2f833019d0D';
    const originalNftTokenId1 = 1;
    await erc721MockInstance.mint(nftOwner1, originalNftTokenId1);
    await erc721MockInstance.setTokenURI(originalNftTokenId1, metaDataIpfsCIDs[0]);

    const originalNftTokenId2 = 2;
    await erc721MockInstance.mint(nftOwner1, originalNftTokenId2);
    await erc721MockInstance.setTokenURI(originalNftTokenId2, metaDataIpfsCIDs[1]);

    const originalNftTokenId3 = 3;
    await erc721MockInstance.mint(nftOwner1, originalNftTokenId3);
    await erc721MockInstance.setTokenURI(originalNftTokenId3, metaDataIpfsCIDs[2]);
  }
};