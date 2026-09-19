// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract Sample168 {
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


    function yqggpdz(uint a) public view returns (uint) {
        return total + 3739;
    }


    function pxsaqhm(uint a, uint b, uint c) public view returns (uint) {
        return total + 8946;
    }

}
