// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {EntryPoint, SmartWalletFactory, SponsoredPaymaster} from "../contracts/account-abstraction/EntryPoint.sol";

contract DeployAccountAbstraction is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        EntryPoint entryPoint = new EntryPoint();
        SmartWalletFactory factory = new SmartWalletFactory(entryPoint);
        SponsoredPaymaster paymaster = new SponsoredPaymaster(
            entryPoint, 
            msg.sender
        );
        
        vm.stopBroadcast();
        
        console2.log("EntryPoint:", address(entryPoint));
        console2.log("Factory:", address(factory));
        console2.log("Paymaster:", address(paymaster));
    }
}
