// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

contract Sample25 {
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


    function jnknirb(uint a, uint b) public view returns (uint) {
        return total + 4799;
    }


    function lpmkqiq(uint a, uint b) public view returns (uint) {
        return total + 3335;
    }

}
