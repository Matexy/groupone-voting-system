// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../src/VotingSystem.sol";
import "../src/ElectionToken.sol"; 

contract VotingSystemTest is Test {
    VotingSystem voting;
    ElectionToken token; 

    // Standard test users
    address voter1 = makeAddr("alice");
    address voter2 = makeAddr("bob");
    address nonHolder = makeAddr("charlie");

    function setUp() public {
        // 1. Create the Token with the name & pass 'address(this)' as the owner
        token = new ElectionToken("TechCrush Airdrop Token", "TCT", 1000000 * 10**18, address(this));
        
        // 2. Create the Voting System
        voting = new VotingSystem(address(token));

        // 3. Fund the voters so they can actually vote
        token.transfer(voter1, 50 * 10**18);
        token.transfer(voter2, 50 * 10**18);
    }

    // Can I create an election? -> YES
    function testCreateElection() public {
        string[] memory candidates = new string[](3);
        candidates[0] = "Alice";
        candidates[1] = "Bob";
        candidates[2] = "Charlie";

        voting.createElection("Class President", candidates, 1 days);
        uint256[] memory results = voting.getResults();
        assertEq(results.length, 3);
    }

    // Can multiple people vote? -> YES
    function testVoting() public {
        string[] memory candidates = new string[](2);
        candidates[0] = "Yes";
        candidates[1] = "No";
        voting.createElection("Referendum", candidates, 1 days);

        vm.prank(voter1);
        voting.vote(1); // Voter 1 votes "No"

        uint256[] memory results = voting.getResults();
        assertEq(results[1], 1); 
        assertTrue(voting.hasVoted(voter1));
    }

    // Can I vote twice? (Should fail!) -> YES
    function testDoubleVoting() public {
        string[] memory candidates = new string[](2);
        candidates[0] = "A";
        candidates[1] = "B";
        voting.createElection("Test", candidates, 1 days);

        vm.startPrank(voter1);
        voting.vote(0); 
        
        vm.expectRevert("Already voted");
        voting.vote(0);
        vm.stopPrank();
    }

    // No tokens = No vote
    function testNoTokens() public {
        string[] memory candidates = new string[](2);
        candidates[0] = "A";
        candidates[1] = "B";
        voting.createElection("Test", candidates, 1 days);

        vm.prank(nonHolder);
        vm.expectRevert("Must hold voting token");
        voting.vote(0);
    }

    // Can we run multiple elections? -> YES
    function testConsecutiveElections() public {
        string[] memory candidates = new string[](2);
        candidates[0] = "A";
        candidates[1] = "B";
        
        // Election 1
        voting.createElection("Round 1", candidates, 1 days);
        vm.prank(voter1);
        voting.vote(0);
        voting.endElection();

        // Election 2
        voting.createElection("Round 2", candidates, 1 days);
        
        // Ensure voter status reset
        assertFalse(voting.hasVoted(voter1)); 
        
        vm.prank(voter1);
        voting.vote(1); 
        assertTrue(voting.hasVoted(voter1));
    }

    // Does voting close after deadline? & Does the right winner get selected? -> YES
    function testWinnerAndDeadline() public {
        string[] memory candidates = new string[](2);
        candidates[0] = "Alice"; // Index 0
        candidates[1] = "Bob";   // Index 1
        
        // Create election that lasts only 100 seconds
        voting.createElection("Quick Vote", candidates, 100);

        // 1. Vote for Bob (Index 1)
        vm.prank(voter1);
        voting.vote(1);

        // 2. Fast forward time by 101 seconds (past the deadline)
        vm.warp(block.timestamp + 101);

        // 3. Try to vote now (Should fail because time passed)
        vm.prank(voter2);
        vm.expectRevert("Election ended");
        voting.vote(0);

        // 4. Check if Bob is the winner
        // Since Bob got 1 vote and Alice got 0, Bob (index 1) should be returned
        uint256 winnerIndex = voting.getWinner();
        assertEq(winnerIndex, 1);
    }
}