const hre = require("hardhat");

async function main() {
  const tokenAddress = "0xYourTokenAddress"; // Ganti dari deploy output
  const nftAddress = "0xYourNFTAddress";
  
  console.log("Verifying Token...");
  await hre.run("verify:verify", {
    address: tokenAddress,
    constructorArguments: ["0x742d35Cc6634C0532925a3b8D7c7aB471A8207a3"]
  });
  
  console.log("Verifying NFT...");
  await hre.run("verify:verify", {
    address: nftAddress,
    constructorArguments: []
  });
}

main().catch(console.error);
