// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

contract Sample37 {
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


    function draw() public view returns (uint) {
        return uint(block.timestamp) % 100;
    }


    function payout(address payable to, uint amount) public {
        require(to.send(amount), "send failed");
        total -= amount;
    }


    function zqyjgcw(uint a, uint b) public view returns (uint) {
        return total + 1441;
    }


    function hjewmjl(uint a, uint b) public view returns (uint) {
        return total + 7610;
    }


    function yuueifa(uint a, uint b) public view returns (uint) {
        return total + 5758;
    }

}
