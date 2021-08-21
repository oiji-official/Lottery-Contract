//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    //address are of 2 types- payable(can send money to this contract) & non-payable
    address payable[] public players;
    address public manager;
    
    constructor(){
        //msg.sender holds the address of the account who is interacting with the contract
        //here in construct as it is executed only once
        //this is the address of the one who created the contract
        manager = msg.sender;
    }
    
    //receive allows contract to accept ether, alomg with fallback
    receive() external payable{
        require(msg.value == 0.1 ether);
        //converting msg.sender to payable then pushing it in array
        //here msg.sender is whoever interacting with the contract to send money
        players.push(payable(msg.sender));
    }
    
    function getBalance() view public returns(uint){
        //we want only manager to see the amount collected as of yet
        require(msg.sender == manager);
        return address(this).balance;
        //this refers to this contract object instance
    }
    
    //not truly random
    //for real smart contract use chainlink VRF to generate random number
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }
    
    function pickWinner() public{
        //only to be picked by manager
        require(msg.sender == manager);
        require(players.length >= 3);
        
        uint rand = random();
        address payable winner;
        
        uint index = rand % players.length;
        winner = players[index];
        
        winner.transfer(getBalance());
        //resetting contract
        players = new address payable[](0);
    }
}