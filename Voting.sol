// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract Election {
    address public owner;
    IERC20 public votingToken;

    struct ElectionData {
        bool active;
        uint256[] voteCounts;
        mapping(address => bool) voted;
    }

    ElectionData private election;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier electionActive() {
        require(election.active, "Election not active");
        _;
    }

    constructor(address _tokenAddress) {
        owner = msg.sender;
        votingToken = IERC20(_tokenAddress);
    }

    /// @notice Create a new election
    function createElection(uint256 numberOfCandidates) external onlyOwner {
        require(!election.active, "Election already active");
        require(numberOfCandidates > 1, "At least 2 candidates required");

        delete election.voteCounts;

        for (uint256 i = 0; i < numberOfCandidates; i++) {
            election.voteCounts.push(0);
        }

        election.active = true;
    }

    /// @notice Vote for a candidate by index
    function vote(uint256 candidateIndex) external electionActive {
        require(!election.voted[msg.sender], "Already voted");
        require(candidateIndex < election.voteCounts.length, "Invalid candidate");
        require(
            votingToken.balanceOf(msg.sender) > 0,
            "Must own voting token"
        );

        election.voteCounts[candidateIndex] += 1;
        election.voted[msg.sender] = true;
    }

    /// @notice End the election
    function endElection() external onlyOwner {
        election.active = false;
    }

    /// @notice Get vote counts for all candidates
    function getResults() external view returns (uint256[] memory) {
        return election.voteCounts;
    }

    /// @notice Check if someone has voted
    function hasVoted(address voter) external view returns (bool) {
        return election.voted[voter];
    }

    /// @notice Get winner (candidate index)
    function getWinner() external view returns (uint256 winnerIndex) {
        uint256 highestVotes = 0;

        for (uint256 i = 0; i < election.voteCounts.length; i++) {
            if (election.voteCounts[i] > highestVotes) {
                highestVotes = election.voteCounts[i];
                winnerIndex = i;
            }
        }
    }
}
