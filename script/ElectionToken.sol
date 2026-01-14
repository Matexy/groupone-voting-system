// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @title CivicPulse Token (CPT)
 * @notice ERC20 token for election voting. Standard-compliant, owner-mintable.
 */
contract ElectionToken {
    // --- ERC20 Metadata ---
    string private _name;
    string private _symbol;
    uint8 private constant _DECIMALS = 18;

    // --- ERC20 Storage ---
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // --- Ownership ---
    address public owner;

    // --- Events ---
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // --- Modifiers ---
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    /**
     * @notice Deploy the token with a name, symbol, and initial supply.
     * @param name_ Human-readable token name (e.g., "CivicPulse Token")
     * @param symbol_ Short ticker (e.g., "CPT")
     * @param initialSupply_ Initial supply in base units (include 18 decimals)
     * @param initialRecipient Address to receive the initial supply
     */
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initialSupply_,
        address initialRecipient
    ) {
        require(initialRecipient != address(0), "Initial recipient is zero");
        _name = name_;
        _symbol = symbol_;
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner);

        _mint(initialRecipient, initialSupply_);
    }

    // --- ERC20 Metadata ---
    function name() external view returns (string memory) { return _name; }
    function symbol() external view returns (string memory) { return _symbol; }
    function decimals() external pure returns (uint8) { return _DECIMALS; }

    // --- ERC20 Views ---
    function totalSupply() external view returns (uint256) { return _totalSupply; }
    function balanceOf(address account) external view returns (uint256) { return _balances[account]; }
    function allowance(address tokenOwner, address spender) external view returns (uint256) {
        return _allowances[tokenOwner][spender];
    }

    // --- ERC20 Core ---
    function transfer(address to, uint256 amount) external returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];
        require(currentAllowance >= amount, "Insufficient allowance");
        unchecked {
            _approve(from, msg.sender, currentAllowance - amount);
        }
        _transfer(from, to, amount);
        return true;
    }

    // --- Owner Minting ---
    function mintTo(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // --- Ownership ---
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "New owner is zero");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    // --- Internal Helpers ---
    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "Transfer from zero");
        require(to != address(0), "Transfer to zero");

        uint256 fromBal = _balances[from];
        require(fromBal >= amount, "Insufficient balance");
        unchecked { _balances[from] = fromBal - amount; }
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _approve(address tokenOwner, address spender, uint256 amount) internal {
        require(tokenOwner != address(0), "Approve from zero");
        require(spender != address(0), "Approve to zero");
        _allowances[tokenOwner][spender] = amount;
        emit Approval(tokenOwner, spender, amount);
    }

    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "Mint to zero");
        _totalSupply += amount;
        _balances[to] += amount;
        emit Transfer(address(0), to, amount);
    }
}
