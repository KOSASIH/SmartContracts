// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, ERC20Burnable, ReentrancyGuard, Ownable {
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 10**18;
    uint256 public constant TAX_RATE = 2; // 2%
    
    address public taxWallet;
    
    event TaxCollected(address indexed from, uint256 amount);
    
    constructor(address _taxWallet) ERC20("MyToken", "MTK") {
        require(_taxWallet != address(0), "Invalid tax wallet");
        taxWallet = _taxWallet;
        _mint(msg.sender, 100_000_000 * 10**18); // 10% initial supply
    }
    
    function _transfer(address from, address to, uint256 amount) 
        internal 
        override 
        nonReentrant 
    {
        require(from != address(0), "Invalid from");
        require(to != address(0), "Invalid to");
        require(amount > 0, "Amount must be > 0");
        
        uint256 taxAmount = (amount * TAX_RATE) / 100;
        uint256 transferAmount = amount - taxAmount;
        
        super._transfer(from, taxWallet, taxAmount);
        super._transfer(from, to, transferAmount);
        
        emit TaxCollected(from, taxAmount);
    }
    
    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");
        _mint(to, amount);
    }
}
