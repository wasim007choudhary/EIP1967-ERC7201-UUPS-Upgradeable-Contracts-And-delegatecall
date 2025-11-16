// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title TU2 Implementation Contract (Upgradeable)
/// @author Wasim
/// @notice This is the upgraded version (V2) of the TU1 contract.
/// @dev
///  - Uses ERC-7201 namespaced storage for upgrade safety
///  - Uses UUPS upgrade mechanism
///  - Storage layout MUST remain consistent between upgrades
///  - Constructor disables initializers to prevent misuse
contract TU2 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    // ---------------------------------------------------------------
    //                        STORAGE (ERC-7201)
    // ---------------------------------------------------------------

    /// @custom:storage-location erc7201:tu1.storage
    /// @dev Contains module-specific state variables for TU1/TU2.
    struct TU1Storage {
        uint256 num;
    }

    /// @notice ERC-7201 storage namespace for TU1/TU2 module.
    bytes32 private constant _TU1_STORAGE_LOCATION =
        keccak256(abi.encode(uint256(keccak256("tu1.storage")) - 1)) & ~bytes32(uint256(0xff));

    function _getTU1Storage() private pure returns (TU1Storage storage $) {
        bytes32 slot = _TU1_STORAGE_LOCATION;
        assembly {
            $.slot := slot
        }
    }

    // ---------------------------------------------------------------
    //                         CONSTRUCTOR
    // ---------------------------------------------------------------

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    // ---------------------------------------------------------------
    //                         INITIALIZER
    // ---------------------------------------------------------------

    /// @notice Initializes the contract during first deployment.
    /// @dev Can only be called once through the proxy.
    function initialize() public initializer {
        __Ownable_init(msg.sender);
    }

    // ---------------------------------------------------------------
    //                       PUBLIC FUNCTIONS
    // ---------------------------------------------------------------

    /// @notice Stores a new number in storage.
    /// @param newNum The number to set.
    function setNumberUsingTU2(uint256 newNum) external onlyOwner {
        TU1Storage storage $ = _getTU1Storage();
        $.num = newNum;
    }

    /// @notice Returns the currently stored number.
    /// @return The stored number.
    function getNumber() external view returns (uint256) {
        return _getTU1Storage().num;
    }

    /// @notice Returns the version number of this implementation.
    /// @return Always returns 2 (for TU2).
    function version() external pure returns (uint256) {
        return 2;
    }

    // ---------------------------------------------------------------
    //                     UUPS UPGRADE AUTHORIZATION
    // ---------------------------------------------------------------

    /// @notice Required by UUPS. Restricts upgrades to the owner.
    /// @param newImplementation Address of the new logic contract.
    /// @dev Override required by UUPSUpgradeable.
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
