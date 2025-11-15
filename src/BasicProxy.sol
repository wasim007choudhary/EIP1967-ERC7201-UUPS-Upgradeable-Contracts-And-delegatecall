// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Proxy} from "@openzeppelin/contracts/proxy/Proxy.sol";

contract BasicProxy is Proxy {
    //keccak256(eip1967.proxy.implementation) - 1. // its the eip1967 standard
    bytes32 private constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function setImplementation(address newImplementation) public {
        assembly {
            sstore(IMPLEMENTATION_SLOT, newImplementation)
        }
    }

    function _implementation() internal view override returns (address implementationAddress) {
        assembly {
            implementationAddress := sload(IMPLEMENTATION_SLOT)
        }
    }

    function getAdd5DataToTransact(uint256 updateNum) public pure returns (bytes memory) {
        return abi.encodeWithSignature("add5(uint256)", updateNum);
    }

    function storageReading() public view returns (uint256 valueAtStorageSlotZero) {
        assembly {
            valueAtStorageSlotZero := sload(0)
        }
    }
}

contract TargetA {
    uint256 public num;

    function add5(uint256 _num) public returns (uint256 result) {
        num = _num + 5;
        result = num;
    }
}

contract TargetB {
    uint256 public num;

    function add5(uint256 _num) public returns (uint256 result) {
        num = _num - 3;
        result = num;
    }
}

// function setImplementation(){}
// Transparent Proxy -> Ok, only admins can call functions on the proxy
// anyone else ALWAYS gets sent to the fallback contract.

// UUPS -> Where all upgrade logic is in the implementation contract, and
// you can't have 2 functions with the same function selector.
