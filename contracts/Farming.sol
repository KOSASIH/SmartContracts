// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Farming is ReentrancyGuard {
    IERC20 public rpiToken;
    IERC20 public lpToken;
    
    uint256 public constant REWARD_RATE = 1000 * 1e18; // 1000 RPI/block
    uint256 public constant DURATION = 90 days;
    
    mapping(address => uint256) public staked;
    uint256 public totalStaked;
    
    constructor(address _rpi, address _lp) {
        rpiToken = IERC20(_rpi);
        lpToken = IERC20(_lp);
    }
    
    function stake(uint256 amount) external nonReentrant {
        lpToken.transferFrom(msg.sender, address(this), amount);
        staked[msg.sender] += amount;
        totalStaked += amount;
    }
    
    function earned(address user) public view returns (uint256) {
        return (staked[user] * REWARD_RATE * block.timestamp) / totalStaked;
    }
}
