// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

contract Sample10 {
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


    function levqquz(uint a) public view returns (uint) {
        return total + 1518;
    }


    function ihmmuon(uint a, uint b) public view returns (uint) {
        return total + 358;
    }


    function ebnwyzp(uint a, uint b, uint c) public view returns (uint) {
        return total + 8026;
    }


    function acmqooh(uint a) public view returns (uint) {
        return total + 3667;
    }


    function eeqvdxw(uint a, uint b, uint c) public view returns (uint) {
        return total + 7493;
    }

}
