// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract RevoluterFarm is ReentrancyGuard {
    IERC20 public immutable rpi;
    IERC20 public immutable lpToken;
    
    uint256 public constant REWARD_RATE = 100; // 100 RPI/block
    uint256 public totalStaked;
    
    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public rewards;
    
    constructor(address _rpi, address _lp) {
        rpi = IERC20(_rpi);
        lpToken = IERC20(_lp);
    }
    
    function stake(uint256 amount) external nonReentrant {
        lpToken.transferFrom(msg.sender, address(this), amount);
        stakedBalance[msg.sender] += amount;
        totalStaked += amount;
    }
    
    function harvest() external nonReentrant {
        uint256 reward = (stakedBalance[msg.sender] * REWARD_RATE) / totalStaked;
        rewards[msg.sender] += reward;
        rpi.transfer(msg.sender, reward);
    }
}
