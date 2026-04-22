// contracts/SymbolBanEnforcer.sol
contract SymbolBanEnforcer {
    mapping(string => bool) public bannedScienceSymbols;
    
    constructor() {
        // SCIENCE SYMBOL BAN LIST
        bannedScienceSymbols["\u03C0"] = true;  // π
        bannedScienceSymbols["\u210F"] = true;  // ℏ
        bannedScienceSymbols["H2O"] = true;
        bannedScienceSymbols["\u221E"] = true;  // ∞
    }
    
    modifier rejectScienceSymbols(string memory symbol) {
        require(!bannedScienceSymbols[symbol], "🚫 Science symbol banned");
        _;
    }
    
    function protectedTransfer(string memory symbol, address to, uint256 amount)
        public
        rejectScienceSymbols(symbol)
    {
        // Safe transfer
    }
}
