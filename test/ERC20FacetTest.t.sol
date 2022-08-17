pragma solidity 0.8.4;

import "./DiamondDeployments.sol";
import "../contracts/Vault/libraries/LibDiamond.sol";
import "../contracts/Vault/libraries/LibKeep.sol";

contract ERC20FacetTest is DDeployments {
    uint256 snapshotId;
    address depositor1;
    uint256 maxDepositorBalance;

    function testERC20VaultOperations() public {
        depositor1 = mkaddr("depositor1");

        //mint some tokens to depositor1
        vm.startPrank(depositor1);
        erc20t.mint(depositor1, 100e18);
        erc20t2.mint(depositor1, 100e18);
        maxDepositorBalance = erc20t.balanceOf(depositor1);
        //approve diamond
        erc20t.approve(vault1, 10000e18);
        erc20t2.approve(vault1, 10000e18);

        //attempt to deposit 2 tokens
        //making sure a failure doesn't revert the whole txn
        v1ERC20Facet.depositERC20Tokens(
            toDualAdd(address(erc20t), address(erc20t2)), toDualUINT(maxDepositorBalance + 10, maxDepositorBalance)
        );

        //confirm deposit
        assertEq(erc20t2.balanceOf(vault1), maxDepositorBalance);
        assertEq(erc20t.balanceOf(vault1), 0);

        //finally deposit properly
        v1ERC20Facet.depositERC20Token(address(erc20t), maxDepositorBalance);
        assertEq(erc20t.balanceOf(vault1), maxDepositorBalance);

        //withdraw some erc20 tokens
        //you have to be the owner
        vm.expectRevert(LibDiamond.NotVaultOwner.selector);
        v1ERC20Facet.withdrawERC20Token(address(erc20t), 10e18, depositor1);
        vm.stopPrank();

        //withdraw normally
        //making sure a failure reverts the whole txn
        uint256 v1erc20BalanceT1 = erc20t.balanceOf(vault1);
        uint256 v1erc20BalanceT2 = erc20t2.balanceOf(vault1);
        vm.startPrank(vault1Owner);
        vm.expectRevert(LibKeep.InsufficientTokens.selector);
        v1ERC20Facet.batchWithdrawERC20Token(
            toDualAdd(address(erc20t), address(erc20t2)), toDualUINT(v1erc20BalanceT1, v1erc20BalanceT2 + 10), depositor1
        );

        //withdraw normally
        //remove all of token2
        v1ERC20Facet.batchWithdrawERC20Token(
            toDualAdd(address(erc20t), address(erc20t2)),
            toDualUINT(v1erc20BalanceT1 - 90e18, v1erc20BalanceT2),
            depositor1
        );

        //confirm balance changes

        assertEq(erc20t2.balanceOf(vault1), 0);
        assertEq(erc20t.balanceOf(vault1), maxDepositorBalance - 10e18);

        ///ALLOCATIONS

        //Allocating a non-existent token
        vm.expectRevert(abi.encodeWithSelector(LibKeep.TokenAllocationOverflow.selector, address(erc20t2), 100e18));
        v1VaultFacet.allocateERC20Tokens(address(erc20t2), toSingletonAdd(vault1Inheritor1), toSingletonUINT(100e18));

        //Allocating to a non-inheritor
        vm.expectRevert(LibKeep.NotInheritor.selector);
        v1VaultFacet.allocateERC20Tokens(address(erc20t2), toSingletonAdd(vault1Inheritor2), toSingletonUINT(100e18));

        //add inheritor 2
        v1VaultFacet.addInheritors(toSingletonAdd(vault1Inheritor2), toSingletonUINT(1000 wei));

        //Allocate normally
        //Allocate all token T1 present in vault 1
        v1erc20BalanceT1 = erc20t.balanceOf(vault1);
        v1VaultFacet.allocateERC20Tokens(
            address(erc20t), toSingletonAdd(vault1Inheritor2), toSingletonUINT(v1erc20BalanceT1)
        );

        //try to allocate token T1 to the first inheritor
        //should overflow
        vm.expectRevert(abi.encodeWithSelector(LibKeep.TokenAllocationOverflow.selector, address(erc20t), 50e18));
        v1VaultFacet.allocateERC20Tokens(address(erc20t), toSingletonAdd(vault1Inheritor1), toSingletonUINT(50e18));

        //free up 50 tokens from inheritor2 by unallocating them
        uint256 inheritor2T1Alloc = v1ERC20Facet.inheritorERC20TokenAllocation(vault1Inheritor2, address(erc20t));
        v1VaultFacet.allocateERC20Tokens(
            address(erc20t), toSingletonAdd(vault1Inheritor2), toSingletonUINT(inheritor2T1Alloc - 50e18)
        );

        //allocate to inheritor1 normally now
        v1VaultFacet.allocateERC20Tokens(address(erc20t), toSingletonAdd(vault1Inheritor1), toSingletonUINT(50e18));

        //confirm allocation
        assertEq(v1ERC20Facet.inheritorERC20TokenAllocation(vault1Inheritor1, address(erc20t)), 50e18);

        //vault owner cannot withdraw any T1 tokens
        vm.expectRevert(LibKeep.InsufficientTokens.selector);
        v1ERC20Facet.withdrawERC20Token(address(erc20t), v1erc20BalanceT1, depositor1);

        //unallocate from an inheritor to free up some tokens
        inheritor2T1Alloc = v1ERC20Facet.inheritorERC20TokenAllocation(vault1Inheritor2, address(erc20t));
        v1VaultFacet.allocateERC20Tokens(
            address(erc20t), toSingletonAdd(vault1Inheritor1), toSingletonUINT(inheritor2T1Alloc - 20e18)
        );

        //withdraw all free tokens
        uint256 unall = v1ERC20Facet.getUnallocatedTokens(address(erc20t));
        v1ERC20Facet.withdrawERC20Token(address(erc20t), unall, depositor1);

        //vault T1 balance should now be made up of all inheritor allocations ONLY
        uint256 inheritor1T1Alloc = v1ERC20Facet.inheritorERC20TokenAllocation(vault1Inheritor1, address(erc20t));
        inheritor2T1Alloc = v1ERC20Facet.inheritorERC20TokenAllocation(vault1Inheritor2, address(erc20t));
        v1erc20BalanceT1 = erc20t.balanceOf(vault1);
        assertEq(v1erc20BalanceT1, inheritor1T1Alloc + inheritor2T1Alloc);
    }
}
