// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RPI is ERC20, ERC20Burnable, ReentrancyGuard, Ownable {
    uint256 public constant MAX_SUPPLY = 100_000_000 * 10**18;
    uint256 public constant BURN_RATE = 1; // 0.1%
    
    address public dexRouter;
    
    constructor(address _dexRouter) ERC20("Revoluter Pi", "RPI") {
        dexRouter = _dexRouter;
        _mint(msg.sender, 40_000_000 * 10**18); // 40% initial
    }
    
    function _transfer(address from, address to, uint256 amount) 
        internal override nonReentrant 
    {
        uint256 burnAmount = (amount * BURN_RATE) / 1000;
        uint256 transferAmount = amount - burnAmount;
        
        super._transfer(from, to, transferAmount);
        super._burn(from, burnAmount);
    }
}
