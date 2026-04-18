async function main() {
  const [deployer] = await ethers.getSigners();
  const taxWallet = process.env.TAX_WALLET;
  const rpiAddress = process.env.RPI_ADDRESS;
  const dexAddress = process.env.DEX_ADDRESS;
  
  console.log("🚀 Deploying with:", deployer.address);
  console.log("📍 RPI:", rpiAddress);
  console.log("💱 DEX:", dexAddress);
  
  // 1. Deploy Token
  const MyToken = await ethers.getContractFactory("MyToken");
  const token = await MyToken.deploy(taxWallet);
  await token.waitForDeployment();
  console.log("✅ Token:", await token.getAddress());
  
  // 2. Deploy NFT  
  const MyNFT = await ethers.getContractFactory("MyNFT");
  const nft = await MyNFT.deploy();
  await nft.waitForDeployment();
  console.log("✅ NFT:", await nft.getAddress());
  
  // 3. Initialize with RPI/DEX (if needed)
  console.log("🔗 RPI Integration Ready:", rpiAddress);
  console.log("🔗 DEX Liquidity Ready:", dexAddress);
}

main().catch(console.error);
