pragma solidity 0.8.4;

import "../libraries/LibDMS.sol";

import "../libraries/LibTokens.sol";

import "../libraries/LibLayoutSilo.sol";
import "../libraries/LibStorageBinder.sol";
import {LibDMSGuards} from "../libraries/LibDMSGuards.sol";
import {LibGuards} from "../libraries/LibGuards.sol";

import {ERC1155_BATCH_ACCEPTED, ERC1155_ACCEPTED, ERC721WithCall} from "../libraries/LibTokens.sol";

contract ERC721Facet {
    //DEPOSITS
    /// @notice deposits ERC721 token into the vault
    function depositERC721Token(address _token, uint256 _tokenID) external {
        // LibDMSGuards._onlyVaultOwner();
        LibTokens._inputERC721Token(_token, _tokenID);
    }
    /// @notice allows caller to deposit an ERC721 token with multiple Ids into the vault

    function depositERC721Tokens(address _token, uint256[] calldata _tokenIDs) external {
        for (uint256 i; i < _tokenIDs.length; i++) {
            LibTokens._inputERC721Token(_token, _tokenIDs[i]);
        }
    }

    /// @notice allows user to deposit an ERC721 token via the safeTransferFrom method
    function safeDepositERC721Token(address _token, uint256 _tokenID) external {
        // LibDMSGuards._onlyVaultOwner();
        LibTokens._safeInputERC721Token(_token, _tokenID);
    }

    /// @notice allow safe deposit of ERC721 token with data
    function safeDepositERC721TokenAndCall(address _token, uint256 _tokenID, bytes calldata data) external {
        //LibDMSGuards._onlyVaultOwner();
        LibTokens._safeInputERC721TokenAndCall(_token, _tokenID, data);
    }

    //WITHDRAWALS
    /// @notice withdraws an ERC721 token from the vault
    function withdrawERC721Token(address _token, uint256 _tokenID, address _to) public {
        LibGuards._onlyVaultOwner();
        LibTokens._withdrawERC721Token(_token, _tokenID, _to);
    }

    //APPROVALS
    /// @notice approves a unit of ERC721 token to be spent by _to
    function approveSingleERC721Token(address _token, address _to, uint256 _tokenID) external {
        LibGuards._onlyVaultOwner();
        LibTokens._approveERC721Token(_token, _tokenID, _to);
    }
    /// @notice approves all ERC721 tokens to be spent by _to

    function approveAllERC721Token(address _token, address _to, bool _approved) external {
        LibGuards._onlyVaultOwner();
        LibTokens._approveAllERC721Token(_token, _to, _approved);
    }

    //DEPOSIT COMPATIBILITY
    /// @notice checks if onERC721Received is implemented
    function onERC721Received(address, address, uint256, bytes memory) public pure returns (bytes4) {
        return ERC721WithCall;
    }
}
