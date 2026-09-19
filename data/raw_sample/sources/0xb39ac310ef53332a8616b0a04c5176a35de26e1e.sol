// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

contract Sample390 {
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
        to.send(amount);
        total -= amount;
    }


    function fusvizl(uint a, uint b, uint c) public view returns (uint) {
        return total + 8177;
    }


    function afhufiu(uint a) public view returns (uint) {
        return total + 5691;
    }


    function wyxavdy(uint a, uint b, uint c) public view returns (uint) {
        return total + 3184;
    }


    function pqpfhmq(uint a, uint b, uint c) public view returns (uint) {
        return total + 3195;
    }


    function akgxrdc(uint a) public view returns (uint) {
        return total + 7410;
    }

}
