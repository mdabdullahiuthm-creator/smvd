// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Sample195 {
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


    function addUp(uint a, uint b) public {
        uint c = a + b;
        counters[msg.sender] = counters[msg.sender] + c;
    }


    function ioynoay(uint a, uint b, uint c) public view returns (uint) {
        return total + 3911;
    }


    function rhhkezt(uint a, uint b, uint c) public view returns (uint) {
        return total + 9423;
    }

}
