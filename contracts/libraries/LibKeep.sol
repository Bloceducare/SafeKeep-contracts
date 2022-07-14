pragma solidity 0.8.4;

import "./LibVaultStorage.sol";
import "./LibDiamond.sol";
import "./LibKeepHelpers.sol";
import "../interfaces/IVaultFacet.sol";
import "../interfaces/IERC20.sol";

library LibKeep {
  event VaultPinged(uint256 lastPing, uint256 vaultID);
  event InheritorsAdded(address[] newInheritors, uint256 vaultID);
  event InheritorsRemoved(address[] inheritors, uint256 vaultID);
  event EthAllocated(address[] inheritors, uint256[] amounts, uint256 vaultID);
  event TokenWithdrawal(
    address token,
    uint256 amount,
    address to,
    uint256 vaultID
  );
  event ErrorHandled(string);
  event TokensAllocated(
    address indexed token,
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
  error TokenDepositFailed(address token);
  error EtherAllocationOverflow(uint256 overflow);
  error TokenAllocationOverflow(address token, uint256 overflow);
  error InactiveInheritor();
  error InsufficientEth();
  error InsufficientTokens();

  //error EthlimitExceeded(uint256 )

  function _anInheritor(address inheritor_) internal view returns (bool inh) {
    VaultStorage storage vs = LibDiamond.vaultStorage();
    for (uint256 i; i < vs.inheritors.length; i++) {
      if (inheritor_ == vs.inheritors[i]) {
        inh = true;
      }
    }
  }

  function _activeInheritor(address _inheritor)
    internal
    view
    returns (bool active_)
  {
    VaultStorage storage vs = LibDiamond.vaultStorage();
    active_ = (vs.activeInheritors[_inheritor]);
  }

  //owner check is in external fn
  function _ping() private {
    VaultStorage storage vs = LibDiamond.vaultStorage();
    vs.lastPing = block.timestamp;
    emit VaultPinged(block.timestamp, vs.vaultID);
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
      for (uint256 x; x < vs.inheritorAllocatedTokens[_inheritor].length; x++) {
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
      totalTokensAllocated += vs.inheritorTokenShares[vs.inheritors[x]][_token];
    }
    return totalTokensAllocated;
  }

  function _notExpired() internal view {
    VaultStorage storage vs = LibDiamond.vaultStorage();
    if (block.timestamp - vs.lastPing > 24 weeks) revert HasExpired();
  }

  //INHERITOR MUTATING OPERATIONS

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

      if (vs.activeInheritors[_newInheritors[k]]) revert ActiveInheritor();

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

  //ALLOCATION MUTATING OPERATIONS

  function _allocateEther(
    address[] calldata _inheritors,
    uint256[] calldata _ethShares
  ) internal {
    if (_inheritors.length == 0 || _ethShares.length == 0) revert EmptyArray();
    if (_inheritors.length != _ethShares.length) revert LengthMismatch();

    VaultStorage storage vs = LibDiamond.vaultStorage();
    for (uint256 k; k < _inheritors.length; k++) {
      if (!_activeInheritor(_inheritors[k])) revert InactiveInheritor();
      //update storage
      vs.inheritorWeishares[_inheritors[k]] = _ethShares[k];
      //make sure limit isn't exceeded
      if (getCurrentAllocatedEth() > address(this).balance)
        revert EtherAllocationOverflow(
          getCurrentAllocatedEth() - address(this).balance
        );
    }
    _ping();
    emit EthAllocated(_inheritors, _ethShares, vs.vaultID);
  }

  function _allocateTokens(
    address token,
    address[] calldata _inheritors,
    uint256[] calldata _shares
  ) internal {
    if (_inheritors.length == 0 || _shares.length == 0) revert EmptyArray();
    if (_inheritors.length != _shares.length) revert LengthMismatch();
    VaultStorage storage vs = LibDiamond.vaultStorage();
    for (uint256 k; k < _inheritors.length; k++) {
      if (!_activeInheritor(_inheritors[k])) revert InactiveInheritor();
      vs.inheritorTokenShares[_inheritors[k]][token] = _shares[k];
      if (!vs.inheritorActiveTokens[_inheritors[k]][token]) {
        vs.inheritorAllocatedTokens[_inheritors[k]].push(token);
        vs.inheritorActiveTokens[_inheritors[k]][token] = true;
      }
      //finally check that limit isn't exceeded
      //get vault token balance
      uint256 currentBalance = IERC20(token).balanceOf(address(this));
      if (getCurrentAllocatedTokens(token) > currentBalance)
        revert TokenAllocationOverflow(
          token,
          getCurrentAllocatedTokens(token) - currentBalance
        );
    }
    _ping();
    emit TokensAllocated(token, _inheritors, _shares, vs.vaultID);
  }

  ///WITHDRAWALS

  function _withdrawEth(uint256 _amount, address _to) internal {
    //confirm free eth is sufficient
    uint256 allocated = getCurrentAllocatedEth();
    if (address(this).balance >= allocated) {
      if (address(this).balance - allocated < _amount) {
        revert InsufficientEth();
      }
      (bool success, ) = _to.call{ value: _amount }("");
      assert(success);
    } else {
      revert InsufficientEth();
    }
  }

  function withdrawTokens(
    address[] calldata _tokenAdds,
    uint256[] calldata _amounts,
    address _to
  ) internal {
    if (_tokenAdds.length == 0 || _amounts.length == 0) revert EmptyArray();
    if (_tokenAdds.length != _amounts.length) revert LengthMismatch();
    VaultStorage storage vs = LibDiamond.vaultStorage();
    for (uint256 x; x < _tokenAdds.length; x++) {
      address token = _tokenAdds[x];
      uint256 amount = _amounts[x];
      uint256 availableTokens = getCurrentAllocatedTokens(token);
      uint256 currentBalance = IERC20(token).balanceOf(address(this));
      if (currentBalance >= availableTokens) {
        if (currentBalance - availableTokens < _amounts[x]) {
          revert InsufficientTokens();
        }
        try IERC20(token).transfer(_to, amount) {} catch {
          //assumes all ERC errors have a revert string
          string memory reason;
          if (bytes(reason).length == 0) {
            emit TokenWithdrawal(token, amount, _to, vs.vaultID);
          } else {
            emit ErrorHandled(reason);
          }
        }
      } else {
        revert InsufficientTokens();
      }
    }
    _ping();
  }
  ///ERC20
  // function _inputTokens(
  //     address[] calldata _tokenDeps,
  //     uint256[] calldata _amounts
  // ) internal {
  //     _notExpired();
  //     if (_tokenDeps.length == 0 || _amounts.length == 0) revert EmptyArray();
  //     if (_tokenDeps.length != _amounts.length) revert LengthMismatch();
  //     //need some interfaces
  // }

  // function _outputTokens(
  //     address[] calldata _tokenAdds,
  //     uint256[] calldata _amounts
  // ) internal {
  //     _notExpired();
  //     if (_tokenAdds.length == 0 || _amounts.length == 0) revert EmptyArray();
  //     if (_tokenAdds.length != _amounts.length) revert LengthMismatch();
  //     //need some interfaces
  // }
  //ERC721
  //ERC1155
}
