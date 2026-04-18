async function main() {
  const [deployer] = await ethers.getSigners();
  
  // 1. Deploy RPI
  const RPI = await ethers.getContractFactory("RPI");
  const rpi = await RPI.deploy("0xDEX_ROUTER_ADDRESS");
  await rpi.waitForDeployment();
  
  // 2. Deploy DEX  
  const DEX = await ethers.getContractFactory("DEX");
  const dex = await DEX.deploy();
  await dex.waitForDeployment();
  
  // 3. Deploy Farming
  const Farming = await ethers.getContractFactory("Farming");
  const farm = await Farming.deploy(await rpi.getAddress(), "0xLP_ADDRESS");
  await farm.waitForDeployment();
  
  console.log(`
🚀 Pi DeFi DEPLOYED!
📈 RPI:  ${await rpi.getAddress()}
💱 DEX:  ${await dex.getAddress()}
🌾 Farm: ${await farm.getAddress()}
  `);
}

main().catch(console.error);
