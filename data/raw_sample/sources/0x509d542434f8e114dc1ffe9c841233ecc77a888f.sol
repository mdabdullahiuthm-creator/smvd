// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Sample392 {
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


    function xmwtmgs(uint a) public view returns (uint) {
        return total + 7311;
    }


    function dtszscq(uint a, uint b) public view returns (uint) {
        return total + 9176;
    }


    function nhpujgp(uint a) public view returns (uint) {
        return total + 301;
    }

}
