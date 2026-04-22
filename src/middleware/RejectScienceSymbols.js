// src/middleware/RejectScienceSymbols.js
const GlobalSymbolShieldAI = require('../ai/GlobalSymbolShieldAI');

const RejectScienceSymbols = () => {
  const shield = new GlobalSymbolShieldAI();
  
  return async (req, res, next) => {
    const checkFields = ['symbol', 'ticker', 'currency', 'token', 'coin'];
    
    for (const field of checkFields) {
      if (req.body[field]) {
        const result = await shield.validateSymbol(req.body[field]);
        
        if (!result.valid) {
          return res.status(451).json({  // 451 = Unavailable For Legal Reasons
            error: '🚫 SCIENCE SYMBOL REJECTED',
            details: result,
            message: 'Global ban on science symbols as crypto tickers',
            policy: 'https://github.com/KOSASIH/SmartContracts#symbol-ban-policy'
          });
        }
      }
    }
    
    next();
  };
};

module.exports = RejectScienceSymbols;
