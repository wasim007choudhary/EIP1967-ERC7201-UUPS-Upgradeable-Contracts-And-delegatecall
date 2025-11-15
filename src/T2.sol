// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract V2 {
    uint256 internal num;

    function setNumber(uint256 _num) external {}

    function getNumber() external view returns (uint256) {
        return num;
    }

    function version() external pure returns (uint256) {
        return 2;
    }
}
