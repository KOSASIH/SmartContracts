// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {UserOperation} from "../../account-abstraction/UserOperation.sol";
import {IEntryPoint} from "../../account-abstraction/interfaces/IEntryPoint.sol";

/**
 * @title IBundler Interface  
 * @author KOSASIH - Ultimate SmartContracts Suite
 * @notice Production bundler interface with MEV + simulation support
 * 
 * Features:
 * ✅ Batch UserOp bundling
 * ✅ MEV-aware ordering
 * ✅ Gas sponsorship integration
 * ✅ Simulation & dry-run
 * ✅ Cross-chain support
 */
interface IBundler {
    /// @notice Extended UserOperation with bundler metadata
    struct BundledUserOperation {
        UserOperation userOp;
        uint256 priorityFee;       // Bundler priority fee
        address sponsor;           // Gas sponsor
        bytes32 bundleId;          // MEV bundle identifier
        bool mevProtected;         // Private mempool flag
    }
    
    /// @notice Bundle simulation parameters
    struct SimulationParams {
        uint256 blockNumber;
        uint256 timestamp;
        address[] preOps;          // Pre-execution calls
        bytes[] postOps;           // Post-execution calls
    }
    
    /**
     * @notice Bundle multiple UserOps with MEV protection
     * @param ops Array of bundled operations
     * @param beneficiary MEV revenue recipient
     * @return aggregatedOpsHash Hash of executed bundle
     */
    function bundleUserOps(
        BundledUserOperation[] calldata ops,
        address payable beneficiary
    ) external returns (bytes32 aggregatedOpsHash);
    
    /**
     * @notice Simulate bundle execution without on-chain execution
     * @dev Returns detailed gas costs and profitability
     */
    function simulateBundle(
        BundledUserOperation[] calldata ops,
        SimulationParams calldata params
    ) external returns (
        uint256 totalGas,
        uint256 totalCost,
        bool profitable,
        string memory report
    );
    
    /**
     * @notice Submit bundle to private mempool (Flashbots)
     * @param ops User operations
     * @param targetBlock Target inclusion block
     * @return bundleId Unique bundle identifier
     */
    function sendPrivateBundle(
        BundledUserOperation[] calldata ops,
        uint256 targetBlock
    ) external returns (bytes32 bundleId);
    
    /**
     * @notice Get bundle status and profitability
     */
    function getBundleStatus(bytes32 bundleId) 
        external view returns (
            string memory status,
            uint256 profit,
            uint256 inclusionBlock
        );
    
    /**
     * @notice Sponsor gas for specific UserOps
     */
    function sponsorOps(
        address paymaster,
        BundledUserOperation[] calldata ops
    ) external payable returns (uint256 sponsoredAmount);
    
    /**
     * @notice MEV-aware UserOp reordering
     * @dev Optimizes for maximum bundler profit
     */
    function reorderForMEV(BundledUserOperation[] calldata ops) 
        external pure returns (BundledUserOperation[] memory optimized);
    
    // Events
    event BundleCreated(bytes32 indexed bundleId, uint256 opCount, address indexed bundler);
    event BundleExecuted(bytes32 indexed bundleId, uint256 profit, address indexed beneficiary);
    event Sponsored(address indexed paymaster, uint256 amount, uint256 opCount);
    event PrivateBundleSubmitted(bytes32 indexed bundleId, uint256 targetBlock);
}
