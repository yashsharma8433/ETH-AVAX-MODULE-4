// 1. Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. 
// Only the owner can mint tokens.
// 2.Transferring tokens: Players should be able to transfer their tokens to others.
// 3.Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
// 4.Checking token balance: Players should be able to check their token balance at any time.
// 5.Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.


pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    // State variable to store the costs of different prizes
    mapping(uint256 => uint256) private prizeCosts;

    // Constructor: It gets executed only once when the contract is deployed.
    constructor() ERC20("Degtoken", "DEGN") {
        // Mint 85 tokens and allocate them to the address that deployed the contract (msg.sender).
        _mint(msg.sender, 85);
        // Initialize prize costs (assuming prize IDs start from 1)
        prizeCosts[1] = 10; // Prize with ID 1 costs 10 tokens
        prizeCosts[2] = 20; // Prize with ID 2 costs 20 tokens
        prizeCosts[3] = 30; // Prize with ID 3 costs 30 tokens
    }

    // Function to mint new tokens and distribute them as rewards. Only the owner can call this function.
    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }

    // Function to redeem a prize by providing the prize ID.
    function redeem(uint256 prizeId) public {
        // Ensure that the provided prize ID is greater than 0.
        require(prizeId > 0, "Prize ID must be greater than zero");
        // Ensure that the prize ID exists in the prizeCosts mapping.
        require(prizeCosts[prizeId] > 0, "Invalid prize ID");
        // Get the cost of the prize with the provided prize ID.
        uint256 cost = prizeCosts[prizeId];
        // Ensure that the sender has enough balance to redeem the prize.
        require(balanceOf(msg.sender) >= cost, "Insufficient balance");

        // Deduct the cost from the sender's account by burning the tokens.
        _burn(msg.sender, cost);

        // just log a message to indicate successful redemption.
        emit PrizeRedeemed(msg.sender, prizeId, cost);
    }

    // Function to transfer tokens to others. Players can use this function to send tokens to other addresses.
    function transferTokens(address recipient, uint256 amount) public {
        // Ensure that the recipient address is valid (not the zero address).
        require(recipient != address(0), "Invalid recipient address");
        // Ensure that the amount to transfer is greater than zero.
        require(amount > 0, "Amount must be greater than zero");
        // Ensure that the sender has enough balance to perform the transfer.
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        // Transfer the specified amount of tokens from the sender to the recipient.
        _transfer(msg.sender, recipient, amount);
    }

    // Function to check the token balance of an address.
    function checkTokenBalance(address account) public view returns (uint256) {
        // Return the balance of the specified account using the balanceOf function provided by the ERC20 contract.
        return balanceOf(account);
    }

    // Function to burn tokens. Anyone can call this function to burn their own tokens that are no longer needed.
    function burnTokens(uint256 amount) public {
        // Ensure that the amount to burn is greater than zero.
        require(amount > 0, "Amount must be greater than zero");
        // Ensure that the sender has enough balance to burn the tokens.
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        // Burn the specified amount of tokens from the sender's account.
        _burn(msg.sender, amount);
    }

    // Event to indicate successful prize redemption.
    event PrizeRedeemed(address indexed account, uint256 prizeId, uint256 cost);
}
