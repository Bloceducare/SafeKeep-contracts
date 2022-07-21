
pragma solidity 0.8.4;
import "../../Vault/libraries/LibKeepHelpers.sol";
struct FactoryAppStorage {
   //master vaultID
uint256 VAULTID;
//mapping(address=>uint[]) userVaults;
//set during diamondDeployment
address diamondCutFacet;
}

library LibAppStorage {
    function factoryAppStorage() internal pure returns (FactoryAppStorage storage fs) {
        assembly {
            fs.slot := 0
        }
    }
}

abstract contract StorageLayout{
    FactoryAppStorage internal fs;

    //  function removeArray(uint256 _val,address _inheritor) public {
    //     LibKeepHelpers.removeUint(fs.userVaults[_inheritor],_val);
    //  }
   
    // function addArray(uint256 _val,address _inheritor) public {
    //     LibKeepHelpers.removeUint(fs.userVaults[_inheritor],_val);
    //  }
}