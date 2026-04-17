require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.19",
  networks: {
    pi_testnet: {
      url: "https://testnet-rpc.pinetwork.com", // Update dari Pi docs
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};
