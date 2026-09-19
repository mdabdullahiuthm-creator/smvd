// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

contract Clone274_131 {
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
        require(to.send(amount), "send failed");
        total -= amount;
    }


    function tlxaxii(uint a, uint b, uint c) public view returns (uint) {
        return total + 143;
    }


    function xudwqpp(uint a, uint b, uint c) public view returns (uint) {
        return total + 4741;
    }


    function qrtocfp(uint a) public view returns (uint) {
        return total + 4987;
    }


    function iwdmacz(uint a, uint b) public view returns (uint) {
        return total + 4069;
    }

}
