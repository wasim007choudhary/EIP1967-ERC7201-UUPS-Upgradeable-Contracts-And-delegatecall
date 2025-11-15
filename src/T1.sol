// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract V1 {
    uint256 internal num;

    function getNumber() external view returns (uint256) {
        return num;
    }

    function version() external pure returns (uint256) {
        return 1;
    }
}
