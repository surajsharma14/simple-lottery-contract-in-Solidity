// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public manager;
    address[] public players;
    
    constructor() {
        manager = msg.sender;
    }
    
    function buyTicket() public payable {
        require(msg.value > 0.01 ether, "Insufficient funds to buy a ticket.");
        
        players.push(msg.sender);
    }
    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }
    
    function selectWinner() public restricted {
        require(players.length > 0, "No players in the lottery.");
        
        uint index = random() % players.length;
        address payable winner = payable(players[index]);
        uint prizeAmount = address(this).balance;
        
        winner.transfer(prizeAmount);
        
        // Resetting the lottery
        players = new address[](0);
    }
    
    modifier restricted() {
        require(msg.sender == manager, "Only the manager can execute this function.");
        _;
    }
}
