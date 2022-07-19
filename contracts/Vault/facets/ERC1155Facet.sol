pragma solidity 0.8.4;

import "../libraries/LibKeep.sol";

import "../libraries/LibTokens.sol";

contract ERC1155Facet is StorageStead {
  struct AllocatedERC1155Tokens {
    uint256 tokenID;
    uint256 amount;
  }

  //VIEW FUNCTIONS
  function getAllocatedERC1155Tokens(address _token, address _inheritor)
    public
    view
    returns (AllocatedERC1155Tokens[] memory alloc_)
  {
    Guards._activeInheritor(_inheritor);
    uint256 tokenCount = vs
    .inheritorAllocatedTokenIds[_inheritor][_token].length;
    if (tokenCount > 0) {
      alloc_ = new AllocatedERC1155Tokens[](tokenCount);
      for (uint256 i; i < tokenCount; i++) {
        uint256 _tid = vs.inheritorAllocatedTokenIds[_inheritor][_token][i];
        alloc_[i].tokenID = _tid;
        alloc_[i].amount = vs.inheritorERC1155TokenAllocations[_inheritor][
          _token
        ][_tid];
      }
    }
  }

  //DEPOSITS
  function depositERC1155Token(
    address _token,
    uint256 _tokenID,
    uint256 _amount
  ) external {
    Guards._onlyVaultOwner();
    LibTokens._safeInputERC1155Token(_token, _tokenID, _amount);
  }

  function BatchDepositERC1155Tokens(
    address _token,
    uint256[] calldata _tokenIDs,
    uint256[] calldata _amounts
  ) external {
    Guards._onlyVaultOwner();
    LibTokens._safeBatchInputERC1155Tokens(_token, _tokenIDs, _amounts);
  }

  //WITHDRAWALS

  function withdrawERC1155Token(
    address _token,
    uint256 _tokenID,
    uint256 _amount,
    address _to
  ) public {
    Guards._onlyVaultOwner();
    LibKeep._withdrawERC1155Token(_token, _tokenID, _amount, _to);
  }

  function BatchWithdrawERC1155Token(
    address _token,
    uint256[] calldata _tokenIDs,
    uint256[] calldata _amount,
    address _to
  ) public {
    Guards._onlyVaultOwner();
    if (_tokenIDs.length > 0) {
      for (uint256 i; i < _tokenIDs.length; i++) {
        withdrawERC1155Token(_token, _tokenIDs[i], _amount[i], _to);
      }
    }
  }

  //APPROVALS
  function approveERC1155Token(
    address _token,
    address _to,
    bool _approved
  ) external {
    Guards._onlyVaultOwner();
    LibTokens._approveAllERC1155Token(_token, _to, _approved);
  }

  //DEPOSIT COMPATIBILITY

function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public pure returns (bytes4) {
        return ERC1155_ACCEPTED;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public pure returns (bytes4) {
        return ERC1155_BATCH_ACCEPTED;
    }

}
