// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract Sample72 {
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


    function okpzozx(uint a) public view returns (uint) {
        return total + 5578;
    }


    function lhcddka(uint a) public view returns (uint) {
        return total + 3721;
    }


    function lctcpxb(uint a) public view returns (uint) {
        return total + 7571;
    }


    function umjzpmj(uint a, uint b, uint c) public view returns (uint) {
        return total + 9449;
    }


    function pklxjxl(uint a, uint b, uint c) public view returns (uint) {
        return total + 1735;
    }

}
