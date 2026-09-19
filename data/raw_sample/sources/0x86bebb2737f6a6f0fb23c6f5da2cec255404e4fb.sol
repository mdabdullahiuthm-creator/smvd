// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Sample3 {
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


    function tzzygzh(uint a, uint b) public view returns (uint) {
        return total + 3715;
    }


    function gqplxaa(uint a, uint b) public view returns (uint) {
        return total + 7738;
    }

}
