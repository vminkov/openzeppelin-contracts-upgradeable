// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

import "../utils/ContextUpgradeable.sol";
import "../proxy/utils/Initializable.sol";

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
    address private _owner;

    /**
     * @notice Pending owner of this contract
     */
    address private pendingOwner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    function __Ownable_init() internal onlyInitializing {
        __Ownable_init_unchained();
    }

    function __Ownable_init_unchained() internal onlyInitializing {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    /**
     * @notice Emitted when pendingOwner is changed
     */
    event NewPendingOwner(address oldPendingOwner, address newPendingOwner);

    /**
     * @notice Emitted when pendingOwner is accepted, which means owner is updated
     */
    event NewOwner(address oldOwner, address newOwner);

    /**
     * @notice Begins transfer of owner rights. The newPendingOwner must call `_acceptOwner` to finalize the transfer.
     * @dev Owner function to begin change of owner. The newPendingOwner must call `_acceptOwner` to finalize the transfer.
     * @param newPendingOwner New pending owner.
     */
    function _setPendingOwner(address newPendingOwner) public onlyOwner {
        // Save current value, if any, for inclusion in log
        address oldPendingOwner = pendingOwner;

        // Store pendingOwner with value newPendingOwner
        pendingOwner = newPendingOwner;

        // Emit NewPendingOwner(oldPendingOwner, newPendingOwner)
        emit NewPendingOwner(oldPendingOwner, newPendingOwner);
    }

    /**
     * @notice Accepts transfer of owner rights. msg.sender must be pendingOwner
     * @dev Owner function for pending owner to accept role and update owner
     */
    function _acceptOwner() public {
        // Check caller is pendingOwner and pendingOwner ≠ address(0)
        require(msg.sender == pendingOwner, "not the pending owner");

        // Save current values for inclusion in log
        address oldOwner = owner();
        address oldPendingOwner = pendingOwner;

        // Store owner with value pendingOwner
        _transferOwnership(pendingOwner);

        // Clear the pending value
        pendingOwner = address(0);

        emit NewOwner(oldOwner, pendingOwner);
        emit NewPendingOwner(oldPendingOwner, pendingOwner);
    }

    function renounceOwnership() public onlyOwner {
        revert("not used anymore");
    }

    function transferOwnership(address newOwner) public onlyOwner {
        revert("not used anymore");
    }
    
    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[48] private __gap;
}
