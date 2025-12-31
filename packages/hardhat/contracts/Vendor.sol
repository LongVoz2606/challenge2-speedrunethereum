pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

    YourToken public yourToken;

    uint256 public constant tokensPerEth = 100;

    constructor(address tokenAddress) Ownable(msg.sender) {
        yourToken = YourToken(tokenAddress);
    }

    // Create a payable buyTokens() function: 
    function buyTokens() public payable {
        uint256 amountOfTokens = msg.value * tokensPerEth;
        yourToken.transfer(msg.sender, amountOfTokens);
        emit BuyTokens(msg. sender, msg.value, amountOfTokens);
    }

    // Create a withdraw() function that lets the owner withdraw ETH
    function withdraw() public onlyOwner {
        (bool success, ) = owner().call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }

    // Create a sellTokens(uint256 _amount) function:
    function sellTokens(uint256 _amount) public {
        uint256 ethToReturn = _amount / tokensPerEth;
        
        require(address(this).balance >= ethToReturn, "Vendor does not have enough ETH");

        yourToken.transferFrom(msg.sender, address(this), _amount);

        (bool success, ) = msg.sender.call{value: ethToReturn}("");
        require(success, "ETH transfer failed");

        emit SellTokens(msg.sender, _amount, ethToReturn);
    }
}