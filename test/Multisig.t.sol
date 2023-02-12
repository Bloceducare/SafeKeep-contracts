pragma solidity 0.8.4;
import "./DiamondDeployments.sol";
import "../contracts/Vault/libraries/LibDiamond.sol";
import "../contracts/Vault/libraries/LibDMS.sol";
import "../contracts/Vault/libraries/LibMultisig.sol";
import "../contracts/interfaces/IVaultFactory.sol";

contract MultisigFacetTest is DDeployments {
    function testVault() public {
        address vaultOwner = LibDiamond.vaultOwner();

        address signer1 = mkaddr("signer1");
        address signer2 = mkaddr("signer2");
        address signer3 = mkaddr("signer3");
        address backup = mkaddr("backup");
        address[] memory signers = new address[](3);
        ModuleManagerFacet(address(vault1)).getActiveModules();
        signers[0] = signer1;
        signers[1] = signer2;
        signers[2] = signer3;
        // testMultisigModule();
        LibMultisig.getSigners();

        ModuleManagerFacet(address(vault1)).getActiveModules();
        multisigFacet.getConfirmedTransactions();
        address own = LibStorageBinder._bindAndReturnFacetStorage().vaultOwner;
        // //activate multisig
        v1dmsFacet.inspectVault();
        DDeployments.addMultisigModule();
        vm.startPrank(vaultOwner);
        multisigFacet.activateMultisig(signers, 2);
        ModuleManagerFacet(address(vault1)).getActiveModules();
        v1dmsFacet.getAllocatedEther();

        // perform DMS operations with multisig
        v1dmsFacet.transferBackup(backup);
    }
}
