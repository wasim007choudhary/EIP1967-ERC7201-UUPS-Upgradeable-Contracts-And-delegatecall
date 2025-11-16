// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {TU1} from "../src/TU1.sol"; // OLD impl interface
import {TU2} from "../src/TU2.sol"; // NEW impl

contract UpgradeTU2 is Script {
    function run() external returns (address) {
        address proxyAddress = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast();

        // Deploy new implementation
        TU2 newImpl = new TU2();

        vm.stopBroadcast();
        return upgradeToTU2(proxyAddress, address(newImpl));
    }

    function upgradeToTU2(address proxyAddress, address newImp) public returns (address) {
        vm.startBroadcast();

        TU1(proxyAddress).upgradeToAndCall(address(newImp), "");
        vm.stopBroadcast();
        return proxyAddress;
    }
}
