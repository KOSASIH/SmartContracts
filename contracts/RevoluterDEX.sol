// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract RevoluterDEX is ReentrancyGuard {
    struct Pair { address token0; address token1; uint256 reserve0; uint256 reserve1; }
    
    mapping(address => mapping(address => Pair)) public pairs;
    address public immutable RPI;
    
    event Swap(address indexed sender, address tokenIn, uint256 amountIn, uint256 amountOut);
    
    constructor(address _rpi) {
        RPI = _rpi;
    }
    
    function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired) 
        external nonReentrant {
        // Simplified AMM logic - production gunakan Uniswap V2 formula
        IERC20(tokenA).transferFrom(msg.sender, address(this), amountADesired);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountBDesired);
        
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        pairs[token0][token1] = Pair(token0, token1, amountADesired, amountBDesired);
    }
    
    function swap(address tokenIn, address tokenOut, uint256 amountIn) external nonReentrant {
        require(tokenIn != tokenOut, "Invalid pair");
        
        Pair memory pair = pairs[tokenIn][tokenOut];
        require(pair.reserve0 > 0 && pair.reserve1 > 0, "No liquidity");
        
        // Constant product formula (x * y = k)
        uint256 amountOut = (pair.reserve1 * amountIn) / (pair.reserve0 + amountIn);
        
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenOut).transfer(address(msg.sender), amountOut);
        
        emit Swap(msg.sender, tokenIn, amountIn, amountOut);
    }
}
