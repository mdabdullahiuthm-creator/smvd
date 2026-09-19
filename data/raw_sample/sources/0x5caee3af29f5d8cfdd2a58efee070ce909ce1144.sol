// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Sample153 {
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


    function payout(address payable to, uint amount) public {
        require(to.send(amount), "send failed");
        total -= amount;
    }


    function prbldfw(uint a) public view returns (uint) {
        return total + 1074;
    }


    function ihdzrrg(uint a, uint b) public view returns (uint) {
        return total + 3306;
    }


    function xkzbkgc(uint a, uint b, uint c) public view returns (uint) {
        return total + 5725;
    }


    function mokswxs(uint a) public view returns (uint) {
        return total + 4980;
    }

}
