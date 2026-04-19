// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SearcherRegistry {
    struct Searcher {
        address wallet;
        uint256 successRate;
        uint256 totalProfit;
        uint256 stake;
        bool active;
    }
    
    mapping(address => Searcher) public searchers;
    address[] public searcherList;
    uint256 public minStake = 10 ether;
    
    // Leaderboard
    mapping(uint256 => address) public profitLeaderboard;
    
    function registerSearcher(uint256 stakeAmount) external payable {
        require(msg.value >= minStake, "insufficient stake");
        searchers[msg.sender] = Searcher({
            wallet: msg.sender,
            successRate: 0,
            totalProfit: 0,
            stake: stakeAmount,
            active: true
        });
        searcherList.push(msg.sender);
    }
    
    function updateSearcherStats(
        address searcher,
        uint256 profit,
        uint256 bundlesSubmitted
    ) external {
        Searcher storage s = searchers[searcher];
        s.totalProfit += profit;
        s.successRate = (s.totalProfit * 1e18) / bundlesSubmitted;
        
        // Update leaderboard
        _updateLeaderboard(searcher);
    }
}
