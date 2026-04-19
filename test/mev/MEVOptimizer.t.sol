contract MEVOptimizerTest is Test {
    MEVOptimizer optimizer;
    FlashbotsRelay relay;
    
    function testProfitableBundle() public {
        // Setup mock Uniswap pools
        // Create arbitrage opportunity
        
        bytes[] memory txs = new bytes[](2);
        txs[0] = _encodeSwap(pool1, 1e18);  // USDC -> WETH
        txs[1] = _encodeSwap(pool2, 1e18);  // WETH -> USDC (profitable)
        
        uint256 profit = relay.simulateProfit(txs);
        assertGt(profit, 0.01 ether);
        
        // Submit bundle
        vm.expectEmit(true, true, true, true);
        emit BundleSubmitted(address(this), profit);
        optimizer.submitMEVBundle(BundleOpportunity({
            blockNumber: block.number + 1,
            transactions: txs,
            minProfit: 0.01 ether,
            searcher: address(this)
        }));
    }
}
