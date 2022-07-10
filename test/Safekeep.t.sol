// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;

import "forge-std/Test.sol";
import "../contracts/SafeKeep.sol";
import "../contracts/MockERC20.sol";

//import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ContractTest is Test {
    SafeKeep keep;
    uint256 vaultID;
    uint256 vaultID2;
    uint256 vaultID3;
    VaultToken token;

    address[] inheritors = [
        0x90F79bf6EB2c4f870365E785982E1f101E93b906,
        0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65,
        0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc,
        0x976EA74026E726554dB657fA54763abd0C3a0aa9
    ];
    uint256[] weiAllocations = [10000, 7874446, 999334, 30000000];

    function setUp() public {
        //setup a safekeep vault with 4 inheritors
        //deploy safekeep

        keep = new SafeKeep();
        token = new VaultToken();
        vaultID = keep.createVault{value: 1 ether}(
            inheritors,
            1 ether,
            address(0xdead)
        );
        vaultID2 = keep.createVault{value: 1 ether}(
            inheritors,
            1 ether,
            address(0xdead)
        );
        vaultID3 = keep.createVault{value: 1 ether}(
            inheritors,
            1 ether,
            address(0xdead)
        );
    }

    function testVault() public {
        keep.checkVault(vaultID);

        //allocate some ether
        keep.allocateEther(vaultID, inheritors, weiAllocations);

        //approve the vault
        IERC20(address(token)).approve(address(keep), 1000000000 ether);

        //  deposit tokens
        keep.depositTokens(
            vaultID,
            toSingletonAdd(address(token)),
            toSingletonUINT(1000e18)
        );

        keep.checkAllAddressVaults(inheritors[0]);
        //allocate some tokens
        keep.allocateTokens(
            vaultID,
            address(token),
            inheritors,
            weiAllocations
        );

        //don't ping vault for 7 months
        skip(block.timestamp + 100 seconds);

        //inheritor1 tries to claim
        hoax(inheritors[0]);
        keep.claim(vaultID);
        keep.checkAllAddressVaults(inheritors[0]);
        keep.claim(vaultID2);
    }

    function toSingletonUINT(uint256 _no)
        private
        pure
        returns (uint256[] memory)
    {
        uint256[] memory arr = new uint256[](1);
        arr[0] = _no;
        return arr;
    }

    function toSingletonAdd(address _no)
        private
        pure
        returns (address[] memory)
    {
        address[] memory arr = new address[](1);
        arr[0] = _no;
        return arr;
    }
}
