pragma solidity 0.8.4;

import "../libraries/LibStorageBinder.sol";
import "../libraries/LibLayoutSilo.sol";

import "./ERC1155Facet.sol";
import "./ERC721Facet.sol";
import "./ERC20Facet.sol";
// import "./VaultFacet.sol";

contract SlotChecker {
    //This is a disposable facet that checks for uniqueness of Master Storage Slots

    function getFacetStorageSlot() public returns (bytes32 _slot) {
        FacetAndSelectorData storage fs = LibStorageBinder
            ._bindAndReturnFacetStorage();
        assembly {
            _slot := fs.slot
        }
    }

    function InterFaceStorageSlot() public returns (bytes32 _slot) {
        InterFaceData storage interFace = LibStorageBinder
            ._bindAndReturnInterfaceStorage();
        assembly {
            _slot := interFace.slot
        }
    }

    function vaultStorageSlot() public returns (bytes32 _slot) {
        DMSData storage vd = LibStorageBinder._bindAndReturnVaultStorage();
        assembly {
            _slot := vd.slot
        }
    }
}
