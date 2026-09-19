// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract Sample338 {
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


    function phymoph(uint a, uint b) public view returns (uint) {
        return total + 5644;
    }


    function tngcrqr(uint a) public view returns (uint) {
        return total + 8295;
    }


    function bfdhegf(uint a, uint b, uint c) public view returns (uint) {
        return total + 8370;
    }


    function vjrsgsc(uint a, uint b) public view returns (uint) {
        return total + 1985;
    }


    function cripfcz(uint a, uint b) public view returns (uint) {
        return total + 3805;
    }

}
