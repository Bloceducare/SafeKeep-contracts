// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

/******************************************************************************\
* Author: Nick Mudge <nick@perfectabstractions.com> (https://twitter.com/mudgen)
* EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
/******************************************************************************/

import { IDiamondCut } from "../../interfaces/IDiamondCut.sol";

import { VaultStorage, NoPermissions } from "../libraries/LibVaultStorage.sol";
import { LibDiamond } from "../VaultDiamond.sol";

contract DiamondCutFacet is IDiamondCut {
  /// @notice Add/replace/remove any number of functions and optionally execute
  ///         a function with delegatecall
  /// @param _diamondCut Contains the facet addresses and function selectors
  /// @param _init The address of the contract or facet to execute _calldata
  /// @param _calldata A function call, including function selector and arguments
  ///                  _calldata is executed with delegatecall on _init
  function diamondCut(
    FacetCut[] calldata _diamondCut,
    address _init,
    bytes calldata _calldata
  ) external override {
    VaultStorage storage vs = LibDiamond.vaultStorage();
    if (tx.origin != vs.vaultOwner) revert NoPermissions();
    LibDiamond.diamondCut(_diamondCut, _init, _calldata);
  }

  //temp call made from factory to confirm ownership
  function tempOwner() public view returns (address owner_) {
    VaultStorage storage vs = LibDiamond.vaultStorage();
    owner_ = vs.vaultOwner;
  }
}
