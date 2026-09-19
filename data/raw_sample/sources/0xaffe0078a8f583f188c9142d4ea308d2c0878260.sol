// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Sample336 {
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


    function gdrcwll(uint a) public view returns (uint) {
        return total + 6214;
    }


    function bpxckex(uint a) public view returns (uint) {
        return total + 2235;
    }


    function qpfrmvc(uint a, uint b, uint c) public view returns (uint) {
        return total + 9068;
    }


    function qfwqycx(uint a, uint b, uint c) public view returns (uint) {
        return total + 354;
    }


    function winnuwr(uint a, uint b, uint c) public view returns (uint) {
        return total + 6622;
    }

}
