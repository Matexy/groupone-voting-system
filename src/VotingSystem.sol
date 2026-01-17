// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @notice Minimal ERC20 interface for token-gated voting
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract VotingSystem {
    address public owner;
    IERC20 public votingToken;

    // Logic to handle multiple elections ---
    uint256 public currentElectionId;
    mapping(address => uint256) private lastVotedElectionId;

    struct ElectionData {
        string title;                 
        string[] candidates;          
        uint256 endTime;              
        bool active;                  
        uint256[] voteCounts;         
    }

    ElectionData private election;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier electionActive() {
        require(election.active, "Election not active");
        require(block.timestamp < election.endTime, "Election ended");
        _;
    }

    constructor(address _tokenAddress) {
        owner = msg.sender;
        votingToken = IERC20(_tokenAddress);
    }

    function createElection(
        string memory _title,
        string[] memory _candidates,
        uint256 _duration
    ) external onlyOwner {
        require(!election.active, "Election already active");
        require(_candidates.length > 1, "At least 2 candidates required");

        // Increment ID so previous voters can vote again
        currentElectionId++;

        delete election.candidates;
        delete election.voteCounts;

        election.title = _title;
        election.endTime = block.timestamp + _duration;
        election.active = true;

        for (uint256 i = 0; i < _candidates.length; i++) {
            election.candidates.push(_candidates[i]);
            election.voteCounts.push(0);
        }
    }

    function endElection() external onlyOwner {
        election.active = false;
    }

    function vote(uint256 candidateIndex) external electionActive {
        // Checks against the CURRENT election ID
        require(lastVotedElectionId[msg.sender] != currentElectionId, "Already voted");
        
        require(candidateIndex < election.candidates.length, "Invalid candidate");
        require(votingToken.balanceOf(msg.sender) > 0, "Must hold voting token");

        election.voteCounts[candidateIndex] += 1;
        
        // Update their record to the CURRENT election ID
        lastVotedElectionId[msg.sender] = currentElectionId;
    }

    function getResults() external view returns (uint256[] memory) {
        return election.voteCounts;
    }

    function getWinner() external view returns (uint256 winnerIndex) {
        uint256 highestVotes = 0;
        for (uint256 i = 0; i < election.voteCounts.length; i++) {
            if (election.voteCounts[i] > highestVotes) {
                highestVotes = election.voteCounts[i];
                winnerIndex = i;
            }
        }
    }

    function hasVoted(address voter) external view returns (bool) {
        return lastVotedElectionId[voter] == currentElectionId;
    }
}