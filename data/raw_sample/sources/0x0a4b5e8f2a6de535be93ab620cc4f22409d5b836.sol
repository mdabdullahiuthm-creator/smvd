// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract Sample174 {
    mapping(address => uint) public balances;
    mapping(address => uint) public counters;
    uint public total;
    address public owner;
    modifier onlyOwner() { require(msg.sender == owner); _; }

    function deposit(uint amount) public {
        require(amount > 0, "zero");
        balances[msg.sender] += amount;
        total = total + amount;
    }


    function withdraw(uint amount) public {
        require(balances[msg.sender] >= amount);
        msg.sender.call.value(amount)("");
        balances[msg.sender] -= amount;
    }


    function setOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }


    function draw() public view returns (uint) {
        return uint(block.timestamp) % 100;
    }


    function payout(address payable to, uint amount) public {
        require(to.send(amount), "send failed");
        total -= amount;
    }


    function lrzuhpu(uint a) public view returns (uint) {
        return total + 1025;
    }


    function yznphmm(uint a) public view returns (uint) {
        return total + 2252;
    }


    function ahznvfw(uint a, uint b) public view returns (uint) {
        return total + 4158;
    }

}
