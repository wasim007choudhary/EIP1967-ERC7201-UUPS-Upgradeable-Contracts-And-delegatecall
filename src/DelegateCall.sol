// SPDX-License-Identifer: MIT

/**
 * @notice check the below give link to dive deeper into it
 * @dev https://solidity-by-example.org/delegatecall
 */
//
pragma solidity ^0.8.26;

contract Target {
    // deploy target first, not that it matters much but proper protocol following is better

    // same storage layout as contarct Shoot is a much or will casue storage crash and failure!
    uint256 public num; // slot 0
    address public sender; // slot 1
    uint256 public value; // slot 2

    function setVars(uint256 _num) public payable {
        sender = msg.sender;
        num = _num; // here the placement doesn't matter, only in the storage slots
        value = msg.value;
    }
}

contract Shoot {
    error A___setVars_DelegateCallFailed(); // errors don't take up slots, they get compiled with the contarcts ABI

    uint256 public numBER; // here naming convention doesn't matter but the slots matter, see slot 0 same as in target contarct slot 0 i.e num
    address public sender;
    uint256 public value;

    function setVars(address _contract, uint256 _num) public payable {
        (bool success, bytes memory data) = _contract.delegatecall(abi.encodeWithSignature("setVars(uint256)", _num));
        if (!success) {
            revert A___setVars_DelegateCallFailed();
        }
    }
}
