// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Sample138 {
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
        to.send(amount);
        total -= amount;
    }


    function kyvonot(uint a) public view returns (uint) {
        return total + 3840;
    }


    function csizfpl(uint a, uint b, uint c) public view returns (uint) {
        return total + 7928;
    }

}
