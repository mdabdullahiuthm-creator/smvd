// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

contract Sample316 {
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


    function gazgrna(uint a, uint b) public view returns (uint) {
        return total + 538;
    }


    function gecvhtn(uint a, uint b) public view returns (uint) {
        return total + 9546;
    }


    function mfrhevu(uint a, uint b, uint c) public view returns (uint) {
        return total + 9044;
    }


    function hcgebri(uint a) public view returns (uint) {
        return total + 9665;
    }

}
