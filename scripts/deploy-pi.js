const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  
  console.log("Deploying with:", deployer.address);
  
  // 1. Deploy RPI Token
  const RevoluterPiToken = await hre.ethers.getContractFactory("RevoluterPiToken");
  const rpi = await RevoluterPiToken.deploy();
  await rpi.deployed();
  console.log("RPI Token:", rpi.address);
  
  // 2. Deploy DEX
  const RevoluterDEX = await hre.ethers.getContractFactory("RevoluterDEX");
  const dex = await RevoluterDEX.deploy(rpi.address);
  await dex.deployed();
  console.log("Revoluter DEX:", dex.address);
  
  // 3. Deploy Farm
  const RevoluterFarm = await hre.ethers.getContractFactory("RevoluterFarm");
  const farm = await RevoluterFarm.deploy(rpi.address, rpi.address);
  await farm.deployed();
  console.log("Revoluter Farm:", farm.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
