contract FullMEVStackTest is Test {
    MEVOptimizer optimizer;
    FlashbotsRelay relay;
    IFlashbots flashbots;
    
    function testEndToEndMEVFlow() public {
        // 1. Create profitable arbitrage bundle
        bytes[] memory profitableTxs = _createArbitrageBundle();
        
        // 2. Simulate first
        uint256 profit = relay.simulateProfit(profitableTxs);
        assertGt(profit, 0.01 ether);
        
        // 3. Submit via optimizer
        optimizer.submitMEVBundle(BundleOpportunity({
            blockNumber: block.number + 1,
            transactions: profitableTxs,
            minProfit: 0.01 ether,
            searcher: address(this)
        }));
        
        // 4. Verify rewards accrued
        assertEq(optimizer.searcherRewards(address(this)), profit * 90 / 100);
    }
}
