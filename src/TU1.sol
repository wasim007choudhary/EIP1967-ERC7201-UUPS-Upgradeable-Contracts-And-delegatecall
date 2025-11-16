// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title TU1 Implementation (Upgradeable)
/// @notice TU1 uses ERC-7201 namespaced storage and UUPS upgrade pattern.
/// @dev Must include a permissioned external `upgradeTo` wrapper because OZ v5.5 makes the internal upgrade helpers not externally available.
contract TU1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    /// @custom:storage-location erc7201:tu1.storage
    struct TU1Storage {
        uint256 num;
    }

    // --------------------------------------------------------------------
    //  ERC-7201 STORAGE SLOT (THE MODULE ROOT)
    // --------------------------------------------------------------------
    bytes32 private constant _TU1_STORAGE_LOCATION =
        keccak256(abi.encode(uint256(keccak256("tu1.storage")) - 1)) & ~bytes32(uint256(0xff));

    function _getTU1Storage() private pure returns (TU1Storage storage $) {
        bytes32 slot = _TU1_STORAGE_LOCATION;
        assembly {
            $.slot := slot
        }
    }

    // --------------------------------------------------------------------
    //  CONSTRUCTOR (DISABLE INITIALIZERS)
    // --------------------------------------------------------------------
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    // --------------------------------------------------------------------
    //  INITIALIZER
    // --------------------------------------------------------------------
    /// @notice Initialize TU1 (set owner)
    /// @dev Should be called via proxy constructor data or via initializer call on proxy.
    function initialize() public initializer {
        __Ownable_init(msg.sender);
    }

    // --------------------------------------------------------------------
    //  PUBLIC FUNCTIONS
    // --------------------------------------------------------------------
    /// @notice Set stored number (owner only).
    /// @param newNum new value to store.
    function setUsingTU1Number(uint256 newNum) external onlyOwner {
        TU1Storage storage $ = _getTU1Storage();
        $.num = newNum;
    }

    /// @notice Read stored number.
    /// @return currently stored value.
    function getNumber() external view returns (uint256) {
        return _getTU1Storage().num;
    }

    /// @notice Implementation version.
    /// @return version id (1).
    function version() external pure returns (uint256) {
        return 1;
    }

    // --------------------------------------------------------------------
    //  UUPS AUTH
    // --------------------------------------------------------------------
    /// @notice Authorize upgrades (internal hook required by UUPS)
    /// @dev Only owner may authorize an upgrade.
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
