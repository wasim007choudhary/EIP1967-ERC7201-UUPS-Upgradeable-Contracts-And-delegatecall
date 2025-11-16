// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {TU1} from "../src/TU1.sol";
import {TU2} from "../src/TU2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployAndUpgradeTest is Test {
    TU1 public tu1;
    TU2 public tu2;
    ERC1967Proxy proxy;

    address owner = address(5);
    address other = address(9);

    function setUp() public {
        tu1 = new TU1();
        bytes memory data = abi.encodeWithSignature("initialize()");
        proxy = new ERC1967Proxy(address(tu1), data);

        // vm.prank(owner); cant call by owner as the test contract is is the who deployd and got set inside initialize
        TU1(address(proxy)).transferOwnership(owner);
    }

    function testVU1afterdeployingAndProxyCalling() public {
        // before upgrade version check
        uint256 expectedVersion = 1;
        uint256 actualVersion = TU1(address(proxy)).version();
        assertEq(expectedVersion, actualVersion);

        // setting number test;
        uint256 numBeforeSetting = TU1(address(proxy)).getNumber();
        vm.prank(owner);
        TU1(address(proxy)).setUsingTU1Number(10);
        assertEq(numBeforeSetting + 10, TU1(address(proxy)).getNumber());

        // willrevert if setNumber not called by owner of the contract or proxy
        vm.expectRevert();
        vm.prank(other);
        TU1(address(proxy)).setUsingTU1Number(100);
    }

    function testUpgradeSuccess() public {
        tu2 = new TU2();
        uint256 expectedVersion = 2;
        vm.prank(owner);
        TU1(address(proxy)).upgradeToAndCall(address(tu2), "");
        uint256 actualVersion = TU2(address(proxy)).version();
        assertEq(expectedVersion, actualVersion);
    }
}
