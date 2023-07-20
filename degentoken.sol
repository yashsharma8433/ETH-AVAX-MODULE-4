//1.Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. 
//Only the owner can mint tokens.
//2.Transferring tokens: Players should be able to transfer their tokens to others.
//3.Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
//4.checking token balance: Players should be able to check their token balance at any time.
//5.Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    constructor() ERC20("Degtoken", "DEGN") {
        _mint(msg.sender, 85);
    }

    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }

    function redeem(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        // Burn the redeemed tokens
        _burn(msg.sender, amount);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function burn(uint256 amount) public {
        require(amount > 0, "amout greater than zero");
        require(balanceOf(msg.sender) >= amount, "Balance Error");

        _burn(msg.sender, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal pure override { }

    function checkBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }
}

