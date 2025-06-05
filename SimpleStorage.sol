// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract SimpleStorage {
    uint256 public number;
mapping(string => uint256) public nameTonumber;
    function one(uint256 _number) public {
    number = _number;
    }
    struct People{
        uint256 number;
        string name;
    }
People[] public people ;
function store(uint256 _number) public {
number = _number ; 
}
function viewer() public view returns(uint256){
    return number;
}
function addPerson(string memory _name , uint256 _number) public{
    people.push(People(_number , _name));
nameTonumber[_name] = _number;
}

}

