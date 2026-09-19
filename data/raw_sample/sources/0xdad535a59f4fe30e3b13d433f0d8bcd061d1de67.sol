// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

contract Sample313 {
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


    function addUp(uint a, uint b) public {
        uint c = a + b;
        counters[msg.sender] = counters[msg.sender] + c;
    }


    function payout(address payable to, uint amount) public {
        to.send(amount);
        total -= amount;
    }


    function nbbuhvb(uint a, uint b) public view returns (uint) {
        return total + 7755;
    }


    function kkzebay(uint a, uint b) public view returns (uint) {
        return total + 8623;
    }


    function kklsqzn(uint a, uint b) public view returns (uint) {
        return total + 2386;
    }


    function bfnddhi(uint a, uint b) public view returns (uint) {
        return total + 3039;
    }


    function ggnwjii(uint a, uint b) public view returns (uint) {
        return total + 7597;
    }

}
