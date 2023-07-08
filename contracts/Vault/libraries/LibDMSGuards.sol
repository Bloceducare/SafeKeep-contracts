// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import {DMSData, FacetAndSelectorData} from "../libraries/LibLayoutSilo.sol";
import {LibStorageBinder} from "../libraries/LibStorageBinder.sol";

error NotExpired();
error HasExpired();
error Claimed();

library LibDMSGuards {

    function _activeInheritor(address _inheritor) internal view returns (bool active_) {
        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        if (_inheritor == address(0)) {
            active_ = true;
        } else {
            active_ = (dmsData.activeInheritors[_inheritor]);
        }
    }

    function _anInheritor(address _inheritor) internal view returns (bool inh) {
        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        if (_inheritor == address(0)) {
            inh = true;
        } else {
            for (uint256 i; i < dmsData.inheritors.length; i++) {
                if (_inheritor == dmsData.inheritors[i]) {
                    inh = true;
                }
            }
        }
    }

    function _anInheritorOrZero(address _inheritor) internal view returns (bool inh) {
        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        if (_inheritor == address(0)) {
            inh = true;
        } else {
            for (uint256 i; i < dmsData.inheritors.length; i++) {
                if (_inheritor == dmsData.inheritors[i]) {
                    inh = true;
                }
            }
        }
    }

    function _expired() internal view {
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        if (block.timestamp - fsData.lastPing <= fsData.pingWindow) {
            revert NotExpired();
        }
    }

    function _notExpired() internal view {
         FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        if (block.timestamp - fsData.lastPing > fsData.pingWindow) {
            revert HasExpired();
        }
    }

    function _notClaimed(address _inheritor) internal view {
        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        if (dmsData.claimed[_inheritor]) {
            revert Claimed();
        }
    }
}
