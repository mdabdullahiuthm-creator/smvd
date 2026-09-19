// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

contract Sample203 {
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


    function rdptgun(uint a) public view returns (uint) {
        return total + 7370;
    }


    function veshnzu(uint a) public view returns (uint) {
        return total + 4943;
    }


    function fgutvwo(uint a, uint b) public view returns (uint) {
        return total + 6880;
    }

}
