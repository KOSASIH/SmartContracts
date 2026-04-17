// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract RevoluterDEX is ReentrancyGuard, Pausable {
    // Storage
    mapping(address => mapping(address => uint256)) public reserves;
    mapping(address => mapping(address => bool)) public isPair;
    
    address public immutable owner;
    uint256 public constant FEE = 30; // 0.3% (30/10000)
    
    event Swap(address indexed sender, address tokenIn, uint256 amountIn, uint256 amountOut);
    event LiquidityAdded(address indexed provider, address tokenA, uint256 amountA, address tokenB, uint256 amountB);
    
    constructor() {
        owner = msg.sender;
    }
    
    // ================== GET AMOUNT OUT (CRITICAL FIX) ==================
    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) 
        public pure returns (uint256 amountOut) {
        require(amountIn > 0, "Insufficient input");
        require(reserveIn > 0 && reserveOut > 0, "Insufficient liquidity");
        
        uint256 amountInWithFee = amountIn * (10000 - FEE);
        uint256 numerator = amountInWithFee * reserveOut;
        uint256 denominator = (reserveIn * 10000) + amountInWithFee;
        amountOut = numerator / denominator;
    }
    
    // ================== SWAP WITH SLIPPAGE PROTECTION ==================
    function swap(address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOutMin) 
        external whenNotPaused nonReentrant {
        require(tokenIn != tokenOut, "Invalid pair");
        require(isPair[tokenIn][tokenOut], "Pair not exists");
        
        uint256 reserveIn = reserves[tokenIn][tokenOut];
        uint256 reserveOut = reserves[tokenOut][tokenIn];
        
        uint256 amountOut = getAmountOut(amountIn, reserveIn, reserveOut);
        require(amountOut >= amountOutMin, "Insufficient output amount");
        
        // Transfer tokens
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenOut).transfer(msg.sender, amountOut);
        
        // Update reserves
        reserves[tokenIn][tokenOut] += amountIn;
        reserves[tokenOut][tokenIn] -= amountOut;
        
        emit Swap(msg.sender, tokenIn, amountIn, amountOut);
    }
    
    // ================== ADD LIQUIDITY ==================
    function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired) 
        external whenNotPaused nonReentrant {
        require(amountADesired > 0 && amountBDesired > 0, "Insufficient amounts");
        
        if (reserves[tokenA][tokenB] == 0) {
            isPair[tokenA][tokenB] = true;
            isPair[tokenB][tokenA] = true;
        }
        
        IERC20(tokenA).transferFrom(msg.sender, address(this), amountADesired);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountBDesired);
        
        reserves[tokenA][tokenB] = amountADesired;
        reserves[tokenB][tokenA] = amountBDesired;
        
        emit LiquidityAdded(msg.sender, tokenA, amountADesired, tokenB, amountBDesired);
    }
    
    // ================== EMERGENCY FUNCTIONS ==================
    function pause() external {
        require(msg.sender == owner, "Not owner");
        _pause();
    }
    
    function unpause() external {
        require(msg.sender == owner, "Not owner");
        _unpause();
    }
    
    // Owner can rescue tokens
    function rescueTokens(address token, address to, uint256 amount) external {
        require(msg.sender == owner, "Not owner");
        IERC20(token).transfer(to, amount);
    }
}
