pragma solidity 0.8.4;

import "../../Vault/libraries/LibKeepHelpers.sol";
import {IModuleData} from "../../interfaces/IModuleData.sol";
struct FactoryAppStorage {
    //master vaultID
    uint256 VAULTID;
    //human readable names to Module data
    mapping(string=>IModuleData.ModuleData) masterModules;
}

library LibFactoryAppStorage {
    function factoryAppStorage() internal pure returns (FactoryAppStorage storage fs) {
        assembly {
            fs.slot := 0
        }
    }
}

abstract contract StorageLayout {
    FactoryAppStorage internal fs;
}
