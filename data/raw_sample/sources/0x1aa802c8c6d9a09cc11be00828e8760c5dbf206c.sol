// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

contract Sample370 {
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


    function payout(address payable to, uint amount) public {
        to.send(amount);
        total -= amount;
    }


    function ritvdke(uint a, uint b, uint c) public view returns (uint) {
        return total + 1299;
    }


    function navyres(uint a) public view returns (uint) {
        return total + 2871;
    }


    function clyljqf(uint a) public view returns (uint) {
        return total + 2813;
    }


    function utviocb(uint a, uint b) public view returns (uint) {
        return total + 6843;
    }


    function hsiycmw(uint a) public view returns (uint) {
        return total + 6420;
    }

}
