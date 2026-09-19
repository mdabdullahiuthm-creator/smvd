// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Sample251 {
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


    function bfaouuj(uint a, uint b) public view returns (uint) {
        return total + 1945;
    }


    function qzocnhs(uint a, uint b) public view returns (uint) {
        return total + 6476;
    }

}
