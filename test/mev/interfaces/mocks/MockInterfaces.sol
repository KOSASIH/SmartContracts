// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {IFlashbots, IBundler} from "../../../../contracts/mev-engine/interfaces/IFlashbots.sol";
import {UserOperation} from "../../../../contracts/account-abstraction/UserOperation.sol";

contract MockFlashbots is IFlashbots {
    function sendBundle(SignedBundle calldata bundle) external override returns (bool) {
        emit BundleSubmitted(bundle.bundleHash, msg.sender, bundle.blockNumber);
        return true;
    }
    
    function simulateBundle(SignedBundle calldata bundle) 
        external pure override returns (SimulationResponse memory) {
        return SimulationResponse({
            success: true,
            profitability: 0.05 ether,
            gasUsed: 500_000,
            error: "",
            executedTxs: bundle.transactions
        });
    }
    
    // Other mock implementations...
}

contract MockBundler is IBundler {
    function bundleUserOps(
        BundledUserOperation[] calldata ops,
        address payable beneficiary
    ) external override returns (bytes32) {
        bytes32 hash = keccak256(abi.encode(ops));
        emit BundleCreated(hash, ops.length, msg.sender);
        return hash;
    }
    
    // Other implementations...
}
