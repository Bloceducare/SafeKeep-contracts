pragma solidity 0.8.4;

//import "../VaultDiamond.sol";
import {FacetAndSelectorData, DMSData} from "../libraries/LibLayoutSilo.sol";
import "../facets/DiamondCutFacet.sol";
import "../facets/DiamondLoupeFacet.sol";
import "../facets/ERC1155Facet.sol";
import "../facets/ERC721Facet.sol";
import "../facets/ERC20Facet.sol";
import "../facets/DMSFacet.sol";
import {MultisigData} from "../libraries/LibMultisigData.sol";

//~(keccak256(abi.encode(slot,200)))
library LibStorageBinder {
    bytes32 constant SLOT_SALT = keccak256("storage_offset_salt");

    /// @notice gets the location where a facet is stored
    function _getStorageSlot(string memory _facetName1) internal pure returns (bytes32 slot) {
        slot = keccak256(bytes(_facetName1));
    }

    /// @notice returns slot of two facets
    function _getStorageSlot(string memory _facetName1, string memory _facetName2)
        internal
        pure
        returns (bytes32 slot)
    {
        slot = keccak256(bytes(abi.encode(_facetName1, _facetName2)));
    }
    //   function _getStorageSlot(
    //     string memory _facetName1,
    //     string memory _facetName2,
    //     string memory _facetName3,
    //     string memory _facetName4,
    //     string memory _facetName5
    // ) internal pure returns (bytes32 slot) {
    //     slot = keccak256(bytes(abi.encode(_facetName1, _facetName2,_facetName3,_facetName4,_facetName5)));
    // }

    /// @notice binds a facet to its storage slot from the diamon loupe facet
    function _bindAndReturnFacetStorage() internal pure returns (FacetAndSelectorData storage selectorData) {
        bytes32 _slot = _getStorageSlot(type(DiamondCutFacet).name, type(DiamondLoupeFacet).name);
        bytes32 saltedOffset = _slot ^ SLOT_SALT;
        assembly {
            selectorData.slot := saltedOffset
        }
    }

    /// @notice binds vault Data to a slot from DMS facet
    function _bindAndReturnDMSStorage() internal pure returns (DMSData storage vaultData) {
        bytes32 _slot = _getStorageSlot(type(DiamondCutFacet).name, type(DMSFacet).name);
        bytes32 saltedOffset = _slot ^ SLOT_SALT;
        assembly {
            vaultData.slot := saltedOffset
        }
    }

    function _bindAndReturnMultisigStorage() internal pure returns (MultisigData storage multisigData) {
        bytes32 _slot = _getStorageSlot(type(DiamondCutFacet).name, type(DMSFacet).name);
        bytes32 saltedOffset = _slot ^ SLOT_SALT;
        assembly {
            multisigData.slot := saltedOffset
        }
    }
}
