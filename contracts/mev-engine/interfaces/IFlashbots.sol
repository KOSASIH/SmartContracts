// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title IFlashbots Interface
 * @author KOSASIH - Ultimate MEV Suite
 * @notice Complete interface for Flashbots Relay v2 + MEV-Share
 * 
 * Supports:
 * ✅ Private mempool bundles
 * ✅ Simulation & profitability checks  
 * ✅ MEV-Share revenue distribution
 * ✅ Block targetting & refunds
 */
interface IFlashbots {
    /// @notice Bundle transaction structure
    struct BundleTransaction {
        uint256 blockNumber;
        bytes transaction;
        bytes inclusionSigns;
    }
    
    /// @notice Signed bundle with MEV-Share parameters
    struct SignedBundle {
        BundleTransaction[] transactions;
        uint256 blockNumber;
        bytes32 bundleHash;
        uint256 coinbaseDiff;      // Minimum payment to block.coinbase
        uint256 refundPercent;     // MEV-Share refund to tx.origin (0-100)
        uint256 maxBlockNumber;    // Latest block for inclusion
        bytes signature;           // EIP-712 signature
    }
    
    /// @notice Bundle simulation response
    struct SimulationResponse {
        bool success;
        uint256 profitability;
        uint256 gasUsed;
        string error;
        BundleTransaction[] executedTxs;
    }
    
    /**
     * @notice Submit bundle to private mempool
     * @dev Only callable by authorized searchers
     */
    function sendBundle(SignedBundle calldata bundle) external returns (bool accepted);
    
    /**
     * @notice Simulate bundle execution
     * @return Detailed profitability analysis
     */
    function simulateBundle(SignedBundle calldata bundle) 
        external view returns (SimulationResponse memory result);
    
    /**
     * @notice Get bundle status by hash
     */
    function getBundleStatus(bytes32 bundleHash) 
        external view returns (string memory status, uint256 blockNumber);
    
    /**
     * @notice MEV-Share refund claim
     */
    function claimRefund(address searcher, uint256 blockNumber) 
        external returns (uint256 refundAmount);
    
    /**
     * @notice Register searcher for priority access
     */
    function registerSearcher(address searcher, uint256 stake) external;
    
    // Events
    event BundleSubmitted(bytes32 indexed bundleHash, address indexed searcher, uint256 blockNumber);
    event BundleExecuted(bytes32 indexed bundleHash, uint256 profit, uint256 gasUsed);
    event RefundClaimed(address indexed searcher, uint256 amount, uint256 blockNumber);
}
