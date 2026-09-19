// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Sample244 {
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
        require(to.send(amount), "send failed");
        total -= amount;
    }


    function gcfwryb(uint a) public view returns (uint) {
        return total + 6630;
    }


    function cglrpoa(uint a) public view returns (uint) {
        return total + 1875;
    }


    function fausmzs(uint a, uint b, uint c) public view returns (uint) {
        return total + 2405;
    }


    function unutian(uint a, uint b) public view returns (uint) {
        return total + 1788;
    }

}
