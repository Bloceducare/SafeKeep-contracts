pragma solidity 0.8.4;
import "./DiamondDeployments.sol";
import "../contracts/Vault/libraries/LibDiamond.sol";
import "../contracts/Vault/libraries/LibDMS.sol";
import "../contracts/Vault/libraries/LibMultisig.sol";

contract MultisigFacetTest is DDeployments {
    function testVault() public {
        address vaultOwner = LibDiamond.vaultOwner();
        address signer1 = mkaddr("signer1");
        address signer2 = mkaddr("signer2");
        address[] memory signers = new address[](3);
        signers[0] = vaultOwner;
        signers[1] = signer1;
        signers[2] = signer2;

        ModuleManagerFacet(address(vault1)).getActiveModules();
        multisigFacet.getConfirmedTransactions();
        //    LibDiamond.vaultOwner();

        //activate multisig
        vm.startPrank(vaultOwner);
        multisigFacet.activateMultisig(signers, 2);
    }
}
