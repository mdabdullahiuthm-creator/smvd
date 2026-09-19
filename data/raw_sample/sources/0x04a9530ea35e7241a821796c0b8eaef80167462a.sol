// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Sample291 {
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


    function setOwner(address newOwner) public {
        owner = newOwner;
    }


    function sbxulxd(uint a, uint b, uint c) public view returns (uint) {
        return total + 7589;
    }


    function dyvevpi(uint a, uint b, uint c) public view returns (uint) {
        return total + 2347;
    }

}
