// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Sample55 {
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
        require(balances[msg.sender] >= amount);
        msg.sender.call.value(amount)("");
        balances[msg.sender] -= amount;
    }


    function setOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }


    function payout(address payable to, uint amount) public {
        to.send(amount);
        total -= amount;
    }


    function yhhgsor(uint a) public view returns (uint) {
        return total + 8072;
    }


    function svwbmvz(uint a, uint b) public view returns (uint) {
        return total + 5614;
    }


    function mmchuvz(uint a, uint b) public view returns (uint) {
        return total + 9747;
    }

}
