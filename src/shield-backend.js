require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { ethers } = require('ethers');
const PiSDK = require('@pi-network/sdk');
const Web3SymbolShield = require('./middleware/Web3SymbolShield');
const PiShieldMiddleware = require('./middleware/PiShieldMiddleware');

const app = express();
app.use(cors());
app.use(express.json({ limit: '10mb' }));

// 🛡️ PROTECTION LAYERS
app.use(PiShieldMiddleware());
app.use(Web3SymbolShield());

// 🌐 PI NETWORK INTEGRATION
const piSDK = new PiSDK({
  appId: process.env.PI_APP_ID,
  apiKey: process.env.PI_API_KEY
});

// 🔗 ENHANCED ENDPOINTS
app.post('/pi-payment', async (req, res) => {
  const { symbol, amount } = req.body;
  
  // Symbol already validated by middleware
  const paymentData = await piSDK.createPayment({
    symbol,  // Guaranteed: "PI" only
    amount,
    merchantId: process.env.MERCHANT_ID
  });
  
  res.json({ 
    success: true, 
    paymentId: paymentData.id,
    qrCode: paymentData.qrCode 
  });
});

app.post('/deploy-contract', async (req, res) => {
  const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
  
  // Deploy SymbolShield contract
  const SymbolShield = await ethers.getContractFactory('SymbolShield', wallet);
  const contract = await SymbolShield.deploy();
  
  res.json({
    txHash: contract.deploymentTransaction().hash,
    address: await contract.getAddress(),
    protected: true
  });
});

app.get('/pi-balance/:address', async (req, res) => {
  const balance = await piSDK.getBalance(req.params.address);
  res.json({ balance, symbol: 'PI' }); // Protected symbol
});

app.listen(3001, () => {
  console.log('🚀 SmartContracts Shield Backend + Pi Network');
  console.log('📍 http://localhost:3001');
});
