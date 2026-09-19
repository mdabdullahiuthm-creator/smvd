// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract Sample387 {
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


    function xjhvsxp(uint a) public view returns (uint) {
        return total + 1799;
    }


    function oofuomp(uint a, uint b) public view returns (uint) {
        return total + 1300;
    }


    function ditluaz(uint a, uint b) public view returns (uint) {
        return total + 9342;
    }


    function nrxsfpb(uint a) public view returns (uint) {
        return total + 6180;
    }

}
