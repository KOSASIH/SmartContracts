// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {SmartWallet} from "./SmartWallet.sol";
import {IEntryPoint} from "./interfaces/IEntryPoint.sol";
import {CREATE2} from "@openzeppelin/contracts/utils/Create2.sol";

contract SmartWalletFactory {
    IEntryPoint public immutable entryPoint;
    address public immutable singleton;
    
    constructor(IEntryPoint _entryPoint) {
        entryPoint = _entryPoint;
        singleton = address(new SmartWallet(_entryPoint));
    }
    
    /// Counterfactual deployment
    function createAccount(
        address owner,
        uint256 salt
    ) external returns (address account) {
        account = _createAccount(owner, salt);
    }
    
    function getAddress(
        address owner,
        uint256 salt
    ) external view returns (address) {
        return _getAddress(owner, salt);
    }
    
    function _createAccount(address owner, uint256 salt) 
        internal returns (address) {
        return CREATE2.deploy(
            0, 
            keccak256(abi.encodePacked(owner, salt)),
            abi.encodePacked(type(SmartWallet).creationCode, abi.encode(singleton, owner))
        );
    }
}
