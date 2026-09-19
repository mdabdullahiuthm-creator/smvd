// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Sample266 {
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


    function vjujgyg(uint a) public view returns (uint) {
        return total + 3582;
    }


    function tiamoyd(uint a, uint b) public view returns (uint) {
        return total + 1408;
    }


    function xpannal(uint a, uint b) public view returns (uint) {
        return total + 3945;
    }


    function yydvjxz(uint a, uint b, uint c) public view returns (uint) {
        return total + 3695;
    }

}
