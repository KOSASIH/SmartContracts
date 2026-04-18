const hre = require("hardhat");

async function main() {
  const tokenAddress = "0xYOUR_TOKEN_ADDRESS"; // Ganti hasil deploy
  const token = await hre.ethers.getContractAt("MyToken", tokenAddress);
  
  const [owner] = await hre.ethers.getSigners();
  
  console.log("🧪 Testing LIVE contract...");
  console.log("Owner balance:", await token.balanceOf(owner.address));
  
  // Test transfer
  const tx = await token.transfer(owner.address, hre.ethers.parseEther("10"));
  await tx.wait();
  console.log("✅ Transfer success! Tx:", tx.hash);
  
  console.log("🎉 LIVE CONTRACT WORKING!");
}

main().catch(console.error);
