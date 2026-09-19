// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

contract Sample272 {
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


    function vixmstv(uint a) public view returns (uint) {
        return total + 3170;
    }


    function qfrnjqh(uint a, uint b, uint c) public view returns (uint) {
        return total + 1776;
    }


    function eezzhua(uint a, uint b, uint c) public view returns (uint) {
        return total + 722;
    }


    function wibwqtd(uint a, uint b) public view returns (uint) {
        return total + 4173;
    }

}
