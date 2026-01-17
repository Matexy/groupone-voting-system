// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../src/ElectionToken.sol";

contract ElectionTokenTest is Test {
    ElectionToken token;
    address deployer = address(this);

    // This function runs automatically before every single test
    function setUp() public {

        // We use the Fun Name and pass the deployer address
        token = new ElectionToken("TechCrush Airdrop Token", "TCT", 1000000 * 10**18, deployer);
    }

    // This is a test to check if the name and symbol are correct
    function testTokenMetadata() public view {
        // Checks if the token's name is exactly "TechCrush Airdrop Token". If not, the test fails
        assertEq(token.name(), "TechCrush Airdrop Token");
        // Checks if the symbol is exactly "TCT"
        assertEq(token.symbol(), "TCT");
    }

    // A test to check if the math for the total supply is right
    function testInitialSupply() public view {
        // Checks if the "deployer" actually owns 1,000,000 tokens (with 18 zeros for decimals)
        assertEq(token.balanceOf(deployer), 1000000 * 10**18);
    }
}