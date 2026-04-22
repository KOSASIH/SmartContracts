// test/symbol-ban.test.js
const shield = new GlobalSymbolShieldAI();

const bannedTests = [
  'πCoin', 'ℏToken', 'H2OToken', '∞Money', 'ΔCrypto', 
  '∑Block', '∫Chain', '∇Token', 'ℯCoin', 'ℝMath'
];

bannedTests.forEach(async (symbol) => {
  const result = await shield.validateSymbol(symbol);
  console.log(`🚫 ${symbol}:`, result.REJECTED); // true
});
