pragma solidity 0.8.4;

import "../../Vault/libraries/LibArrayHelpers.sol";

struct FactoryAppStorage {
    //master vaultID
    uint256 VAULTID;
    //mapping(address=>uint[]) userVaults;

    //set during Master Diamond Deployment
    //used to upgrade individual vaults
    address diamondCutFacet;
    address erc20Facet;
    address erc721Facet;
    address erc1155Facet;
    address diamondLoupeFacet;
    address vaultFacet;
    address slotChecker;
    //facet selector data for spawned vaults

    bytes4[] ERC20SELECTORS;
    bytes4[] ERC721SELECTORS;
    bytes4[] ERC1155SELECTORS;
    bytes4[] DIAMONDLOUPEFACETSELECTORS;
    bytes4[] VAULTFACETSELECTORS;
    bytes4[] SLOTCHECKERSELECTORS;
}

library LibAppStorage {
    function factoryAppStorage()
        internal
        pure
        returns (FactoryAppStorage storage fs)
    {
        assembly {
            fs.slot := 0
        }
    }
}

abstract contract StorageLayout {
    FactoryAppStorage internal fs;

    //  function removeArray(uint256 _val,address _inheritor) public {
    //     LibKeepHelpers.removeUint(fs.userVaults[_inheritor],_val);
    //  }

    // function addArray(uint256 _val,address _inheritor) public {
    //     LibKeepHelpers.removeUint(fs.userVaults[_inheritor],_val);
    //  }
}
