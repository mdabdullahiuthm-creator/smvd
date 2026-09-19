// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

contract Sample44 {
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


    function hwagbmo(uint a) public view returns (uint) {
        return total + 9878;
    }


    function jqudghx(uint a) public view returns (uint) {
        return total + 2114;
    }


    function tbcczsk(uint a, uint b, uint c) public view returns (uint) {
        return total + 2240;
    }

}
