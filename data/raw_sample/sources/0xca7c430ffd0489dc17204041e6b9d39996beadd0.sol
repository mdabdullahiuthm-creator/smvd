// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

contract Sample300 {
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


    function setOwner(address newOwner) public {
        owner = newOwner;
    }


    function draw() public view returns (uint) {
        return uint(block.timestamp) % 100;
    }


    function jbaqxgi(uint a, uint b, uint c) public view returns (uint) {
        return total + 9096;
    }


    function frjfpby(uint a, uint b) public view returns (uint) {
        return total + 9158;
    }

}
