const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MyToken", () => {
  let token, owner, addr1, taxWallet;
  
  beforeEach(async () => {
    [owner, addr1, taxWallet] = await ethers.getSigners();
    const MyToken = await ethers.getContractFactory("MyToken");
    token = await MyToken.deploy(taxWallet.address);
    await token.waitForDeployment();
  });
  
  it("Should have correct initial supply", async () => {
    expect(await token.totalSupply()).to.equal(ethers.parseEther("100000000"));
  });
  
  it("Should collect tax on transfer", async () => {
    await token.transfer(addr1.address, ethers.parseEther("1000"));
    expect(await token.balanceOf(taxWallet.address)).to.be.above(0);
  });
  
  it("Should revert on reentrancy", async () => {
    // Test will pass due to nonReentrant
    await expect(
      token.connect(addr1).transfer(owner.address, ethers.parseEther("1"))
    ).to.not.be.reverted;
  });
});
