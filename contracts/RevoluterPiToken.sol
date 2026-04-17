// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract RevoluterPiToken is ERC20, Ownable, ERC20Burnable {
    uint256 public constant MAX_SUPPLY = 100_000_000 * 10**18;
    uint256 public totalBurned;
    
    event TokensBurned(address indexed burner, uint256 amount);
    
    constructor() ERC20("Revoluter Pi", "RPI") {
        _mint(msg.sender, 10_000_000 * 10**18); // 10% initial supply
    }
    
    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");
        _mint(to, amount);
    }
    
    function burn(uint256 amount) public override {
        super.burn(amount);
        totalBurned += amount;
        emit TokensBurned(msg.sender, amount);
    }
}
