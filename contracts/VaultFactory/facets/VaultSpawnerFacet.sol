pragma solidity 0.8.4;

import "../../Vault/VaultDiamond.sol";
import "../../Vault/libraries/LibDMS.sol";
import "../../interfaces/IVaultDiamond.sol";

import {IDiamondCut} from "../../interfaces/IDiamondCut.sol";
import "../../interfaces/IVaultFacet.sol";

import {FactoryAppStorage, StorageLayout} from "../libraries/LibFactoryAppStorage.sol";

contract VaultSpawnerFacet is StorageLayout {
    event VaultCreated(
        address indexed owner,
        uint256 indexed startingBalance,
        uint256 vaultID
    );

    error BackupAddressError();

    function createVault(address _vaultOwner, uint256 _startingBal,address _backupAddress, uint256 _backupDelay)
        external
        payable
        returns (address addr)
    {
        if (_startingBal > 0) {
            assert(_startingBal == msg.value);
        }
        //spawn contract
        bytes32 entropy = keccak256(abi.encode(_vaultOwner, fs.VAULTID));

        //get Selector and Token Module FacetCuts
        IDiamondCut.FacetCut[] storage selectorModuleCut = fs
            .masterModules["Selector"]
            .facetData;
        IDiamondCut.FacetCut[] storage tokenModuleCut = fs
            .masterModules["Token"]
            .facetData;

        VaultDiamond vDiamond = new VaultDiamond{
            salt: entropy,
            value: _startingBal
        }(selectorModuleCut, tokenModuleCut, _vaultOwner, _backupAddress, _backupDelay,fs.VAULTID);
        addr = address(vDiamond);
        emit VaultCreated(msg.sender, _startingBal, fs.VAULTID);
        fs.VAULTID++;
    }
}
