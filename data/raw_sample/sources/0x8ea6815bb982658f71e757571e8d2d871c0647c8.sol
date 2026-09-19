// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Sample184 {
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
        require(amount > 0, "zero");
        balances[msg.sender] += amount;
        total = total + amount;
    }


    function setOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }


    function payout(address payable to, uint amount) public {
        require(to.send(amount), "send failed");
        total -= amount;
    }


    function eqgnkmd(uint a, uint b, uint c) public view returns (uint) {
        return total + 2715;
    }


    function gcqpwyp(uint a, uint b, uint c) public view returns (uint) {
        return total + 9574;
    }

}
