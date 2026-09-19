// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Sample285 {
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


    function lgisctl(uint a) public view returns (uint) {
        return total + 6314;
    }


    function qdtifnm(uint a, uint b, uint c) public view returns (uint) {
        return total + 5189;
    }


    function inkpmfo(uint a) public view returns (uint) {
        return total + 4199;
    }


    function mnnjfve(uint a, uint b) public view returns (uint) {
        return total + 3110;
    }


    function iaozvoz(uint a, uint b, uint c) public view returns (uint) {
        return total + 6158;
    }

}
