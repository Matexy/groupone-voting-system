🗳️ Simple Voting System (TechCrush Airdrop Token – TCT)
📌 Deployed Contract Addresses
Contract Name	                        Network	                           Address
TechCrush Airdrop Token (TCT)	        Sepolia	                      PASTE_TOKEN_ADDRESS_HERE
Voting System Contract	                Sepolia	                      PASTE_VOTING_CONTRACT_ADDRESS_HERE


📝 Project Overview

This project is a transparent, tamper-proof voting system built on the Ethereum blockchain using Foundry.

It consists of two main smart contracts:

ElectionToken (TCT)
An ERC20 token called TechCrush Airdrop Token (TCT) used for governance and voting rights.

VotingSystem
A smart contract that manages elections and only allows users who hold TCT tokens to vote.

This system ensures that:

Only token holders can vote

Each address can vote only once per election

Results are publicly verifiable on-chain


🗳️ Election Used for Testing

For the final test and deployment, we created an election titled:

"Best Programming Language"

Candidates
Index	Name
  0	    Solidity
  1	    Rust
  2	    JavaScript


Voting Logic

Each wallet address can vote once

A user must hold TCT tokens to vote

Votes are counted on-chain

The election closes automatically when the deadline is reached


Determining the Winner

The getWinner() function loops through all vote counts and returns the candidate with the highest number of votes.

In our test run, Solidity won by receiving the highest number of votes.


🛠️ Functions Implemented

The following required functions were implemented:

createElection() – Allows the contract owner to create a new election

vote(uint candidateIndex) – Cast a vote for a candidate

getResults() – Returns the vote counts for all candidates

getWinner() – Returns the name of the winning candidate

hasVoted(address voter) – Checks if an address has already voted


✅ Testing Checklist

All required behaviors were verified using Foundry tests:

 Election can be created by the owner

 Multiple addresses can vote

 Double voting is prevented

 Voting stops after the deadline

 Winner is correctly determined
 

⚙️ How to Run Locally
1. Install Dependencies
forge install OpenZeppelin/openzeppelin-contracts

2. Run Tests
forge test -vv

3. Deploy Contracts
forge script script/DeployVoting.s.sol --rpc-url <YOUR_RPC_URL> --private-key <YOUR_PRIVATE_K