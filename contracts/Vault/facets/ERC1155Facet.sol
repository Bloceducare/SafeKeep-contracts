pragma solidity 0.8.4;

import "../libraries/LibDMS.sol";

import {LibTokens,ERC1155_ACCEPTED,ERC1155_BATCH_ACCEPTED} from "../libraries/LibTokens.sol";

import "../libraries/LibLayoutSilo.sol";
import "../libraries/LibStorageBinder.sol";
import "../libraries/LibGuards.sol";

contract ERC1155Facet {
  //DEPOSITS
  function depositERC1155Token(
    address _token,
    uint256 _tokenID,
    uint256 _amount
  ) external {
   // LibGuards._onlyVaultOwner();
    LibTokens._safeInputERC1155Token(_token, _tokenID, _amount);
  }

  function batchDepositERC1155Tokens(
    address _token,
    uint256[] calldata _tokenIDs,
    uint256[] calldata _amounts
  ) external {
   // LibGuards._onlyVaultOwner();
    LibTokens._safeBatchInputERC1155Tokens(_token, _tokenIDs, _amounts);
  }

  //WITHDRAWALS

  function withdrawERC1155Token(
    address _token,
    uint256 _tokenID,
    uint256 _amount,
    address _to
  ) public {
    LibGuards._onlyVaultOwner();
    LibTokens._withdrawERC1155Token(_token, _tokenID, _amount, _to);
  }

  function batchWithdrawERC1155Token(
    address _token,
    uint256[] calldata _tokenIDs,
    uint256[] calldata _amount,
    address _to
  ) public {
    LibGuards._onlyVaultOwner();
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
    LibGuards._onlyVaultOwner();
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
