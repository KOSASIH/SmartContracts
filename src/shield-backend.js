const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const Web3SymbolShield = require('./middleware/Web3SymbolShield');
const PiShieldMiddleware = require('./middleware/PiShieldMiddleware');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// 🛡️ DOUBLE PROTECTION LAYERS
app.use(PiShieldMiddleware());
app.use(Web3SymbolShield());

// 🔗 SMART CONTRACT ENDPOINTS (PROTECTED)
app.post('/deploy', (req, res) => {
  console.log('🚀 Protected Contract Deploy:', req.body.symbol);
  res.json({ txHash: '0x...', protected: true });
});

app.post('/swap', (req, res) => {
  res.json({ success: true, symbol: req.body.symbol }); // π BLOCKED!
});

app.get('/shield-status', (req, res) => {
  res.json({
    protection: 'ACTIVE',
    blocks: ['π', 'ℏ', 'H2O', '∞'],
    allowed: ['PI', 'BTC', 'ETH']
  });
});

app.listen(3001, () => {
  console.log('🛡️ SmartContracts Symbol Shield ACTIVE on :3001');
});
