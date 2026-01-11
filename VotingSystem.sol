// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @notice Minimal ERC20 interface for token-gated voting
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract Election {
    address public owner;
    IERC20 public votingToken;

    /// @notice Election structure as required
    struct ElectionData {
        string title;                 // Election title
        string[] candidates;          // List of candidates
        uint256 endTime;              // Voting end time (timestamp)
        bool active;                  // Election status
        uint256[] voteCounts;         // Votes per candidate
        mapping(address => bool) voted; // Tracks if address has voted
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

    /// @notice Creates a new election
    /// @param _title Title of the election
    /// @param _candidates List of candidates
    /// @param _duration Duration of election in seconds
    function createElection(
        string memory _title,
        string[] memory _candidates,
        uint256 _duration
    ) external onlyOwner {
        require(!election.active, "Election already active");
        require(_candidates.length > 1, "At least 2 candidates required");

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

    /// @notice Vote for a candidate by index
    /// @param candidateIndex Index of the candidate
    function vote(uint256 candidateIndex) external electionActive {
        require(!election.voted[msg.sender], "Already voted");
        require(candidateIndex < election.candidates.length, "Invalid candidate");
        require(
            votingToken.balanceOf(msg.sender) > 0,
            "Must hold voting token"
        );

        election.voteCounts[candidateIndex] += 1;
        election.voted[msg.sender] = true;
    }

    /// @notice Returns vote counts for all candidates
    function getResults() external view returns (uint256[] memory) {
        return election.voteCounts;
    }

    /// @notice Returns the index of the winning candidate
    function getWinner() external view returns (uint256 winnerIndex) {
        uint256 highestVotes = 0;

        for (uint256 i = 0; i < election.voteCounts.length; i++) {
            if (election.voteCounts[i] > highestVotes) {
                highestVotes = election.voteCounts[i];
                winnerIndex = i;
            }
        }
    }

    /// @notice Checks if an address has voted
    /// @param voter Address to check
    function hasVoted(address voter) external view returns (bool) {
        return election.voted[voter];
    }
}
