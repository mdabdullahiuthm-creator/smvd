// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Sample128 {
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


    function cbshcel(uint a, uint b, uint c) public view returns (uint) {
        return total + 6724;
    }


    function ztarlxq(uint a) public view returns (uint) {
        return total + 8842;
    }

}
