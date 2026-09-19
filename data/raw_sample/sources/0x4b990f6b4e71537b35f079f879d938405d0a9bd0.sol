// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Sample299 {
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


    function draw() public view returns (uint) {
        return uint(block.timestamp) % 100;
    }


    function eqoilwm(uint a) public view returns (uint) {
        return total + 2192;
    }


    function sumokdv(uint a, uint b) public view returns (uint) {
        return total + 621;
    }


    function cfsfwdz(uint a, uint b, uint c) public view returns (uint) {
        return total + 6326;
    }


    function jxdrixq(uint a, uint b) public view returns (uint) {
        return total + 4449;
    }


    function gdwtyij(uint a, uint b) public view returns (uint) {
        return total + 625;
    }

}
