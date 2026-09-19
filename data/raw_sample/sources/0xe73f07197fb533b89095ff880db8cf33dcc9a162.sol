// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

contract Sample374 {
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


    function ttbwuws(uint a, uint b, uint c) public view returns (uint) {
        return total + 819;
    }


    function xiclegl(uint a) public view returns (uint) {
        return total + 8511;
    }


    function nblvpde(uint a) public view returns (uint) {
        return total + 3571;
    }

}
