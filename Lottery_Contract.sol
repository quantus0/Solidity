// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract SimpleLottery {
    address public manager;
    address[] public players;

    constructor() {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value == 0.01 ether, "Entry fee is 0.01 ETH");
        players.push(msg.sender);
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }

    function pickWinner() public restricted {
        require(players.length > 0, "No players entered");

        uint index = random() % players.length;
        address payable winner = payable(players[index]);
        winner.transfer(address(this).balance);

        // Reset players for next round
        players = new address[](0);
    }

    modifier restricted() {
        require(msg.sender == manager, "Only manager can call this");
        _;
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }
}
