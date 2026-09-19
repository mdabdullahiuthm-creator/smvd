// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract Sample385 {
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


    function addUp(uint a, uint b) public {
        uint c = a + b;
        counters[msg.sender] = counters[msg.sender] + c;
    }


    function bpavsrp(uint a, uint b, uint c) public view returns (uint) {
        return total + 223;
    }


    function csgsewo(uint a, uint b, uint c) public view returns (uint) {
        return total + 7434;
    }


    function fpphmzm(uint a, uint b, uint c) public view returns (uint) {
        return total + 106;
    }


    function orksdnq(uint a) public view returns (uint) {
        return total + 9906;
    }

}
