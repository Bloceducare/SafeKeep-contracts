pragma solidity 0.8.4;

import "../libraries/LibKeep.sol";

import "../libraries/LibTokens.sol";

contract ERC20Facet is StorageStead {
  struct AllocatedERC20Tokens {
    address token;
    uint256 amount;
  }

  function getAllocatedERC20Tokens(address _inheritor)
    public
    view
    returns (AllocatedERC20Tokens[] memory tAllocs)
  {
    Guards._activeInheritor(_inheritor);
    uint256 count = vs.inheritorAllocatedERC20Tokens[_inheritor].length;
    if (count > 0) {
      tAllocs = new AllocatedERC20Tokens[](count);
      for (uint256 i; i < count; i++) {
        address _t = vs.inheritorAllocatedERC20Tokens[_inheritor][i];
        tAllocs[i].amount = vs.inheritorTokenShares[_inheritor][_t];
        tAllocs[i].token = _t;
      }
    }
  }

  function inheritorERC20TokenAllocation(address _inheritor, address _token)
    public
    view
    returns (uint256)
  {
    return vs.inheritorTokenShares[_inheritor][_token];
  }

  //DEPOSITS
  function depositERC20Token(address _token, uint256 _amount) external {
    Guards._onlyVaultOwner();
    LibTokens._inputERC20Token(_token, _amount);
  }

  function depositERC20Tokens(
    address[] calldata _tokens,
    uint256[] calldata _amounts
  ) external {
    Guards._onlyVaultOwner();
    LibTokens._inputERC20Tokens(_tokens, _amounts);
  }

  //WITHDRAWALS

  function withdrawERC20Token(
    address _token,
    uint256 _amount,
    address _to
  ) public {
    Guards._onlyVaultOwner();
    LibKeep._withdrawERC20Token(_token, _amount, _to);
  }

  function BatchWithdrawERC20Token(
    address[] calldata _tokens,
    uint256[] calldata _amounts,
    address _to
  ) public {
    Guards._onlyVaultOwner();
    LibKeep._withdrawERC20Tokens(_tokens, _amounts, _to);
  }

  //APPROVALS
  function approveERC20Token(
    address _token,
    address _to,
    uint256 _amount
  ) external {
    Guards._onlyVaultOwner();
    LibTokens._approveERC20Token(_token, _to, _amount);
  }
}
