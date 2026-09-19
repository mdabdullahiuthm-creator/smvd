// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Sample129 {
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


    function payout(address payable to, uint amount) public {
        to.send(amount);
        total -= amount;
    }


    function ecqebvi(uint a, uint b, uint c) public view returns (uint) {
        return total + 5309;
    }


    function fvjgorh(uint a, uint b, uint c) public view returns (uint) {
        return total + 1812;
    }


    function dvqautc(uint a, uint b, uint c) public view returns (uint) {
        return total + 7297;
    }

}
