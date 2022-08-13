pragma solidity 0.8.4;

interface IVaultDiamond {
   
function init(address _diamondCutFacet,address _backupAddress,uint256 _id) external;

//via delegatecall on diamond
 function vaultOwner() external view returns (address) ;

  function tempOwner() external view returns(address owner_);
    
}
