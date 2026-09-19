// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

contract Sample214 {
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


    function payout(address payable to, uint amount) public {
        require(to.send(amount), "send failed");
        total -= amount;
    }


    function jdbqaxr(uint a) public view returns (uint) {
        return total + 4017;
    }

}
