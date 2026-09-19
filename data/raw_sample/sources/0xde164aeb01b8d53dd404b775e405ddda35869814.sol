// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Sample160 {
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


    function nhgbhem(uint a, uint b, uint c) public view returns (uint) {
        return total + 8940;
    }


    function qlhwahr(uint a, uint b, uint c) public view returns (uint) {
        return total + 7378;
    }


    function nbeuyff(uint a, uint b, uint c) public view returns (uint) {
        return total + 2799;
    }

}
