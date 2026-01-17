
# 🗳️ Simple Voting System (Group One) 

A secure, blockchain-based voting application where eligibility is determined by holding the **TechCrush Airdrop Token (TCT)**. This system allows for transparent election creation, voting, and result tallying on the Ethereum blockchain.

## 📍 Deployed Contracts (Anvil Localnet)

| Contract Name | Address |
| :--- | :--- |
| **Voting System** | `0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512` |
| **TechCrush Token (TCT)** | `0x5FbDB2315678afecb367f032d93F642f64180aa3` |

---

## 🚀 Key Features

* **Token-Gated Voting:** Only users holding **TCT** tokens can vote.
* **One Person, One Vote:** Strict checks ensure a user cannot vote twice in the same election.
* **Consecutive Elections:** *[NEW]* Fixed logic allows the system to run multiple elections back-to-back. Voter status resets automatically when a new election starts.
* **Time-Bound:** Elections automatically close after the specified deadline.

---

## 🧪 Testing & Coverage

We achieved **100% Test Coverage** on the Voting System logic, ensuring all scenarios (winning, double voting, time limits) are handled correctly.

### Run Tests
To verify our test results:
```bash
forge test

```

### Coverage Report

To see the coverage metrics:

```bash
forge coverage

```

**Results:**

* ✅ **VotingSystem.sol:** 100% Line Coverage / 100% Function Coverage
* ✅ **ElectionToken.sol:** Verified Metadata & Supply

---

## 📜 How It Works (Election Cycle)

### 1. Setup

The deployment script creates the **TechCrush Airdrop Token (TCT)** with an initial supply of **1,000,000 TCT**. These tokens are distributed to voters to give them "voting power."

### 2. Creating an Election

The owner creates a new election with a list of candidates and a time limit.

* **Example:** "Class President"
* **Candidates:** `['Alice', 'Bob', 'Charlie']`
* **Duration:** 1 Day

### 3. Voting

Token holders call the `vote(candidateIndex)` function.

* **Rule:** Must hold > 0 TCT.
* **Rule:** Can only vote once per election ID.

### 4. Results

Anyone can call `getResults()` or `getWinner()` to see the live tally.

* **Winner Determination:** The contract automatically calculates which index has the highest vote count.

---

## 🛠️ Technical Stack

* **Language:** Solidity ^0.8.30
* **Framework:** Foundry (Forge, Anvil, Script)
* **Token Standard:** ERC20

## 🔧 Installation & Deployment

**1. Clone the Repository**

```bash
git clone [https://github.com/matexy/groupone-voting-system](https://github.com/matexy/groupone-voting-system)
cd groupone-voting-system

```

**2. Install Dependencies**

```bash
forge install

```

**3. Deploy to Local Blockchain (Anvil)**

```bash
# Start Anvil in a separate terminal
anvil

# Deploy Script
forge script script/DeployVoting.s.sol --fork-url [http://127.0.0.1:8545](http://127.0.0.1:8545) --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

```

```

---

### **Final Step: Push to GitHub**
Once you have pasted and saved the file above, run these last commands in your terminal to finish everything:

```bash
git add README.md
git commit -m "Update README with deployed addresses and project info"
git push origin main

```