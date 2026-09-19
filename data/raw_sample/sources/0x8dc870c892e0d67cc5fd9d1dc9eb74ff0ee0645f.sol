// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

contract Sample188 {
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


    function setOwner(address newOwner) public {
        owner = newOwner;
    }


    function payout(address payable to, uint amount) public {
        to.send(amount);
        total -= amount;
    }


    function ggjfdsp(uint a, uint b) public view returns (uint) {
        return total + 9151;
    }


    function gwkgfqt(uint a, uint b, uint c) public view returns (uint) {
        return total + 2404;
    }


    function qzddzed(uint a) public view returns (uint) {
        return total + 3946;
    }


    function lknpvgz(uint a, uint b) public view returns (uint) {
        return total + 2386;
    }

}
