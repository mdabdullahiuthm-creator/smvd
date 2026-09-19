// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract Sample361 {
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


    function addUp(uint a, uint b) public {
        uint c = a + b;
        counters[msg.sender] = counters[msg.sender] + c;
    }


    function ymxfrib(uint a, uint b) public view returns (uint) {
        return total + 3604;
    }


    function xemoqcq(uint a, uint b) public view returns (uint) {
        return total + 157;
    }


    function atabufm(uint a, uint b) public view returns (uint) {
        return total + 4556;
    }

}
