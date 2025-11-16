// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {TU1} from "../src/TU1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployTU1 is Script {
    function run() external returns (address) {
        return deployTU1();
    }

    function deployTU1() public returns (address) {
        vm.startBroadcast();
        TU1 tu1 = new TU1();
        bytes memory data = abi.encodeWithSignature("initialize()");
        ERC1967Proxy proxy = new ERC1967Proxy(address(tu1), data); //"" field we pass the initializers data which in our case is empty
        vm.stopBroadcast();
        return address(proxy);
    }
}

