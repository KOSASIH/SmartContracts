const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("RevoluterDEX", function () {
  let dex, rpi, weth, owner, user;
  
  beforeEach(async function () {
    [owner, user] = await ethers.getSigners();
    
    const RPI = await ethers.getContractFactory("RevoluterPiToken");
    rpi = await RPI.deploy();
    
    const WETH = await ethers.getContractFactory("RevoluterPiToken");
    weth = await WETH.deploy();
    
    const DEX = await ethers.getContractFactory("RevoluterDEX");
    dex = await DEX.deploy();
    
    // Add liquidity
    await rpi.mint(user.address, ethers.parseEther("1000"));
    await weth.mint(user.address, ethers.parseEther("1000"));
    
    await rpi.connect(user).approve(dex.target, ethers.parseEther("1000"));
    await weth.connect(user).approve(dex.target, ethers.parseEther("1000"));
    
    await dex.connect(user).addLiquidity(
      await rpi.getAddress(),
      await weth.getAddress(),
      ethers.parseEther("100"),
      ethers.parseEther("100")
    );
  });
  
  it("should swap with slippage protection", async function () {
    const amountIn = ethers.parseEther("10");
    const amountOutMin = ethers.parseEther("9"); // Allow 10% slippage
    
    await expect(dex.connect(user).swap(
      await rpi.getAddress(),
      await weth.getAddress(),
      amountIn,
      amountOutMin
    )).to.emit(dex, "Swap");
  });
  
  it("should revert on high slippage", async function () {
    const amountIn = ethers.parseEther("10");
    const amountOutMin = ethers.parseEther("99"); // Impossible
    
    await expect(dex.connect(user).swap(
      await rpi.getAddress(),
      await weth.getAddress(),
      amountIn,
      amountOutMin
    )).to.be.revertedWith("Insufficient output amount");
  });
});
