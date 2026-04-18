// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DEX is ReentrancyGuard {
    struct Pair {
        address token0;
        address token1;
        uint256 reserve0;
        uint256 reserve1;
    }
    
    mapping(address => mapping(address => Pair)) public pairs;
    
    event Swap(address indexed pair, address indexed from, uint256 amountIn, uint256 amountOut);
    
    function swap(
        address tokenIn, 
        address tokenOut, 
        uint256 amountIn,
        uint256 amountOutMin
    ) external nonReentrant {
        require(amountIn > 0, "Invalid amount");
        
        Pair storage pair = pairs[tokenIn][tokenOut];
        require(pair.reserve0 > 0 && pair.reserve1 > 0, "No liquidity");
        
        uint256 amountOut = getAmountOut(amountIn, pair.reserve0, pair.reserve1);
        require(amountOut >= amountOutMin, "Insufficient output");
        
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenOut).transfer(msg.sender, amountOut);
        
        emit Swap(tokenIn, msg.sender, amountIn, amountOut);
    }
    
    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) 
        public pure returns (uint256) 
    {
        uint256 amountInWithFee = amountIn * 997; // 0.3% fee
        return (amountInWithFee * reserveOut) / (reserveIn + amountInWithFee);
    }
}
