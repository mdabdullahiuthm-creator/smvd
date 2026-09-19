// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

contract Sample224 {
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


    function viynocl(uint a, uint b, uint c) public view returns (uint) {
        return total + 391;
    }


    function imnpnuz(uint a, uint b) public view returns (uint) {
        return total + 8141;
    }


    function zjxczxx(uint a) public view returns (uint) {
        return total + 855;
    }

}
