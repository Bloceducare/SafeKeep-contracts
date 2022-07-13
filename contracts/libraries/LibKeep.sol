pragma solidity 0.8.4;

import "./LibVaultStorage.sol";
import "./LibDiamond.sol";
import "./LibKeepHelpers.sol";
import "../interfaces/IVaultFacet.sol";

library LibKeep {
    event VaultPinged(uint256 lastPing, uint256 vaultID);
    event InheritorsAdded(address[] newInheritors, uint256 vaultID);
    event InheritorsRemoved(address[] inheritors, uint256 vaultID);
    event EthAllocated(
        address[] inheritors,
        uint256[] amounts,
        uint256 vaultID
    );

    error LengthMismatch();
    error HasExpired();
    error ActiveInheritor();
    error NotEnoughEtherToAllocate();
    error EmptyArray();
    error NotInheritor();

    function _anInheritor(address inheritor_) internal view returns (bool inh) {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        for (uint256 i; i < vs.inheritors.length; i++) {
            if (inheritor_ == vs.inheritors[i]) {
                inh = true;
            }
        }
    }

    function getCurrentAllocatedEth() internal view returns (uint256) {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        uint256 totalEthAllocated;
        for (uint256 x; x < vs.inheritors.length; x++) {
            totalEthAllocated += vs.inheritorWeishares[vs.inheritors[x]];
        }
        return totalEthAllocated;
    }

    //only used for multiple address elemented arrays
    function reset(address _inheritor) internal {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        vs.inheritorWeishares[_inheritor] = 0;
        //resetting all token allocations if he has any
        if (vs.inheritorAllocatedTokens[_inheritor].length > 0) {
            for (
                uint256 x;
                x < vs.inheritorAllocatedTokens[_inheritor].length;
                x++
            ) {
                vs.inheritorTokenShares[_inheritor][
                    vs.inheritorAllocatedTokens[_inheritor][x]
                ] = 0;
                vs.inheritorActiveTokens[_inheritor][
                    vs.inheritorAllocatedTokens[_inheritor][x]
                ] = false;
            }
            //remove all token addresses
            delete vs.inheritorAllocatedTokens[_inheritor];
        }
    }

    function getCurrentAllocatedTokens(address _token)
        internal
        view
        returns (uint256)
    {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        uint256 totalTokensAllocated;
        for (uint256 x; x < vs.inheritors.length; x++) {
            totalTokensAllocated += vs.inheritorTokenShares[vs.inheritors[x]][
                _token
            ];
        }
        return totalTokensAllocated;
    }

    function _notExpired() internal view {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        if (block.timestamp - vs.lastPing > 24 weeks) revert HasExpired();
    }

    function _addInheritors(
        address[] calldata _newInheritors,
        uint256[] calldata _weiShare
    ) internal {
        if (_newInheritors.length == 0 || _weiShare.length == 0)
            revert EmptyArray();
        if (_newInheritors.length != _weiShare.length) revert LengthMismatch();
        _notExpired();
        uint256 total;
        uint256 allocated = LibKeep.getCurrentAllocatedEth();
        VaultStorage storage vs = LibDiamond.vaultStorage();
        for (uint256 k; k < _newInheritors.length; k++) {
            total += _weiShare[k];

            if (vs.activeInheritors[_newInheritors[k]])
                revert ActiveInheritor();

            if (total + allocated > address(this).balance)
                revert NotEnoughEtherToAllocate();
            vs.inheritorWeishares[_newInheritors[k]] = _weiShare[k];
            //append the inheritors for a vault
            vs.inheritors.push(_newInheritors[k]);
            vs.activeInheritors[_newInheritors[k]] = true;

            //in global LibAppStorage
            // userVaults[_newInheritors[k]].push(_vaultId);
        }
        _ping();
        emit InheritorsAdded(_newInheritors, vs.vaultID);
        emit EthAllocated(_newInheritors, _weiShare, vs.vaultID);
    }

    function _removeInheritors(address[] calldata _inheritors) internal {
        if (_inheritors.length == 0) revert EmptyArray();
        _notExpired();
        VaultStorage storage vs = LibDiamond.vaultStorage();
        for (uint256 k; k < _inheritors.length; k++) {
            if (!vs.activeInheritors[_inheritors[k]]) revert NotInheritor();
            vs.activeInheritors[_inheritors[k]] = false;
            //pop out the address from the array
            LibKeepHelpers.removeAddress(vs.inheritors, _inheritors[k]);

            //should interact with master diamond to mutate record
            //remember to safeguard
            //LibKeepHelpers.removeUint(userVaults[_inheritors[k]], vs.vaultID);
            reset(_inheritors[k]);
        }
        _ping();
        emit InheritorsRemoved(_inheritors, vs.vaultID);
    }

    //owner check is in external fn
    function _ping() private {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        vs.lastPing = block.timestamp;
        emit VaultPinged(block.timestamp, vs.vaultID);
    }
}
