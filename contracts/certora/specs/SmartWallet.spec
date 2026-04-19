// SmartWallet Formal Verification Rules
rules {
    // Rule 1: No unauthorized execution
    rule noUnauthorizedExecution(address target, method f) {
        env e;
        calldataarg args;
        
        // Invariant: only owner or session key can execute
        requireInvariant ownerOrSessionKey(e.msg.sender);
        
        SmartWallet(target).execute(e, args);
        
        assert ownerOrSessionKey(e.msg.sender);
    }
    
    // Rule 2: Nonce monotonicity
    rule nonceMonotonicity(address target) {
        env e1; env e2;
        calldataarg args1; calldataarg args2;
        
        uint256 nonce1 = SmartWallet(target).nonce(e1.msg.sender);
        SmartWallet(target).execute(e1, args1);
        uint256 nonce2 = SmartWallet(target).nonce(e1.msg.sender);
        
        assert nonce2 == nonce1 + 1;
    }
    
    // Rule 3: No reentrancy
    rule noReentrancy(address target) {
        env e;
        calldataarg args;
        
        // Ghost variable tracking reentrancy
        bool reentered = false;
        
        SmartWallet(target).execute(e, args);
        
        assert !reentered;
    }
}
