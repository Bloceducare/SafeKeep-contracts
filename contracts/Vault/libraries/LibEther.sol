pragma solidity 0.8.4;

import {LibModuleManager} from "../libraries/LibModuleManager.sol";
import {LibDMS} from "../libraries/LibDMS.sol";
import {LibErrors} from "../libraries/LibErrors.sol";
import {LibDiamond} from "../libraries/LibDiamond.sol";

library LibEther {
    error InsufficientEth();
    error EthWithdrawalError();
error AmountMismatch();

 event EthDeposited(uint256 _amount,address _from, uint256 _vaultID);
  event EthWithdrawn(uint256 _amount,address _to, uint256 _vaultID);

 function _depositEther(uint256 _amount) internal {
        if (_amount != msg.value) {
            revert AmountMismatch();
        }
        emit EthDeposited(_amount,msg.sender, LibDiamond.vaultID());
    }

    function _withdrawEth(uint256 _amount, address _to) internal {
        //confirm free eth is sufficient
        uint256 availableEther = address(this).balance;

        if (LibModuleManager._isActiveModule("DMS")) {
            uint256 allocated = LibDMS.getCurrentAllocatedEth();
            availableEther -= allocated;
            if (_amount > availableEther) revert InsufficientEth();
        }
        if (availableEther >= _amount) {
            (bool success,) = _to.call{value: _amount}("");
            assert(success);
        } else {
            revert EthWithdrawalError();
        }
        emit EthWithdrawn(_amount,_to, LibDiamond.vaultID());
    }


}
