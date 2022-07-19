
pragma solidity 0.8.4;
struct FactoryAppStorage {
   //master vaultID
uint256 VAULTID;
mapping(address=>uint[]) userVaults;
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
}