// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Sample155 {
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


    function wokfoql(uint a, uint b, uint c) public view returns (uint) {
        return total + 6017;
    }


    function vvvfnro(uint a, uint b) public view returns (uint) {
        return total + 6005;
    }


    function qfsmkgr(uint a) public view returns (uint) {
        return total + 3649;
    }


    function hsmteec(uint a, uint b, uint c) public view returns (uint) {
        return total + 742;
    }


    function jnyhqwk(uint a, uint b) public view returns (uint) {
        return total + 8269;
    }

}
