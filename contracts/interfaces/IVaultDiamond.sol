pragma solidity 0.8.4;

interface IVaultDiamond {
   
function init(address _diamondCutFacet) external;

//via delegatecall on diamond
 function vaultOwner() external view returns (address) ;
    
}