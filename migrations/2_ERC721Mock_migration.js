const ERC721Mock = artifacts.require("ERC721Mock");
const metaDataIpfsCIDs = [
  "QmWzdJBT6w6ABZ4oxFMxJaB6cpwLaWTGthTmSVWbuEenCK",
  "QmZjh3giC15jYAnCvvFVQhuBSsvPgx5KUkGg94qkbbQbV9",
  "Qmf6QNNxW5LvKmqtwQ7VmhjWnciq7LwBzDLheKWdBKvmzA",
  "QmZ54eSPBHQYCF7szFtf7Hq89jcAhzScjUaTBCWFdLvnj3",
  "QmQwSXhN3RXc4FS4oWPFPTemvwiaiQwLLnbgYuz2TwTR1a",
  "QmTFhTDC8LMuHaFsyNWFgWTXJBjZ4DK9VyxbZDRePBqTB1"];

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

    const originalNftTokenId4 = 4;
    await erc721MockInstance.mint(nftOwner1, originalNftTokenId4);
    await erc721MockInstance.setTokenURI(originalNftTokenId4, metaDataIpfsCIDs[3]);

    const originalNftTokenId5 = 5;
    await erc721MockInstance.mint(nftOwner1, originalNftTokenId5);
    await erc721MockInstance.setTokenURI(originalNftTokenId5, metaDataIpfsCIDs[4]);

    const originalNftTokenId6 = 6;
    await erc721MockInstance.mint(nftOwner1, originalNftTokenId6);
    await erc721MockInstance.setTokenURI(originalNftTokenId6, metaDataIpfsCIDs[5]);
  }
};