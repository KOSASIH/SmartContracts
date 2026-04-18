async function main() {
  const [deployer] = await ethers.getSigners();
  
  console.log("Deploying contracts with:", deployer.address);
  
  // Deploy Token
  const MyToken = await ethers.getContractFactory("MyToken");
  const token = await MyToken.deploy("0xYourTaxWalletHere");
  await token.waitForDeployment();
  
  console.log("Token deployed:", await token.getAddress());
  
  // Deploy NFT
  const MyNFT = await ethers.getContractFactory("MyNFT");
  const nft = await MyNFT.deploy();
  await nft.waitForDeployment();
  
  console.log("NFT deployed:", await nft.getAddress());
}

main().catch(console.error);
