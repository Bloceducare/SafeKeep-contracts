pragma solidity 0.8.4;

import "./DiamondDeployments.sol";
import "../contracts/Vault/libraries/LibDiamond.sol";
import "../contracts/Vault/libraries/LibKeep.sol";

contract EtherOpsTest is DDeployments{
//   struct VaultFacet.AllInheritorEtherAllocs {
//     address inheritor;
//     uint256 weiAlloc;
//   }


function testAllVaultEtherOperations() public{
vm.startPrank(vault1Owner);


//get ether allocation data for all inheritors
//only one inheritor currently present
VaultFacet.AllInheritorEtherAllocs[] memory eAllocs=new VaultFacet.AllInheritorEtherAllocs[](1);
eAllocs[0]=VaultFacet.AllInheritorEtherAllocs({inheritor:vault1Inheritor1,weiAlloc:10000});
//get data onchain
VaultFacet.AllInheritorEtherAllocs[] memory onchainAllocs=v1VaultFacet.allEtherAllocations();
assertEq(onchainAllocs[0].inheritor,eAllocs[0].inheritor);
assertEq(onchainAllocs[0].weiAlloc,eAllocs[0].weiAlloc);

//confirm free ether available for withdrawal
uint256 freeEther=v1VaultFacet.getUnallocatedEther();
uint256 onchainFreeEther=v1VaultFacet.getUnallocatedEther();
assertEq(freeEther,onchainFreeEther);

//add another inheritor and allocate some ether
uint256 v1Inheritor2eAlloc=freeEther - 10000000;

//try to allocate more thn available ether
vm.expectRevert(abi.encodeWithSelector(LibKeep.EtherAllocationOverflow.selector,2 ether -freeEther));
v1VaultFacet.addInheritors(toSingletonAdd(vault1Inheritor2),toSingletonUINT(2 ether));

//allocate normally
v1VaultFacet.addInheritors(toSingletonAdd(vault1Inheritor2),toSingletonUINT(v1Inheritor2eAlloc));
uint256 v1Inheritor2EtherAlloc= v1VaultFacet.inheritorEtherAllocation(vault1Inheritor2);
assertEq(v1Inheritor2EtherAlloc,freeEther - 10000000);

//try to withdraw more than available
freeEther=v1VaultFacet.getUnallocatedEther();
vm.expectRevert(LibKeep.InsufficientEth.selector);
v1VaultFacet.withdrawEther(freeEther+1000,vault1Owner);

//unallocate from both inheritors
//ORDER matters(not really anymore)
v1VaultFacet.allocateEther(toDualAdd(vault1Inheritor2,vault1Inheritor1),toDualUINT(v1Inheritor2eAlloc-500,10000-500));
v1VaultFacet.withdrawEther(freeEther+1000,vault1Owner);

//no more free ether
freeEther=v1VaultFacet.getUnallocatedEther();
assertEq(freeEther,0);
v1VaultFacet.allEtherAllocations();

}

}