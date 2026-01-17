// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/ElectionToken.sol";
import "../src/VotingSystem.sol";

contract DeployVoting is Script {
    function run() external {
        // Starts the "recording". Any command after this line will actually be sent to the blockchain using a private key.
        vm.startBroadcast();

        // 1. Name is "TechCrush Airdrop Token" (Requirement: Fun name)
        // 2. Added 'msg.sender' at the end because the contract constructor requires 
        //    an initial recipient address (the 4th argument).
        ElectionToken token = new ElectionToken(
            "TechCrush Airdrop Token", 
            "TCT", 
            1000000 * 10**18, 
            msg.sender
        );
        
        VotingSystem voting = new VotingSystem(address(token));

        // Stops the "recording" to the blockchain. The transaction is finished.
        vm.stopBroadcast();
    }
}