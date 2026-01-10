// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/ElectionToken.sol";
import "../src/VotingSystem.sol";

contract DeployVoting is Script {
    function run() external {
        // No keys here, just starting the recorder
        vm.startBroadcast(); 

        ElectionToken token = new ElectionToken(
            "TechCrush Airdrop Token", 
            "TCT", 
            1_000_000 * 10**18
        );

        VotingSystem voting = new VotingSystem(address(token));

        vm.stopBroadcast();
    }
}