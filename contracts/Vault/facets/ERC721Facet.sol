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

    function depositERC721Token(address _token, uint256 _tokenID) external {
        // LibDMSGuards._onlyVaultOwner();
        LibTokens._inputERC721Token(_token, _tokenID);
    }

    function depositERC721Tokens(address _token, uint256[] calldata _tokenIDs) external {
        for (uint256 i; i < _tokenIDs.length; i++) {
            LibTokens._inputERC721Token(_token, _tokenIDs[i]);
        }
    }

    function safeDepositERC721Token(address _token, uint256 _tokenID) external {
        // LibDMSGuards._onlyVaultOwner();
        LibTokens._safeInputERC721Token(_token, _tokenID);
    }

    function safeDepositERC721TokenAndCall(
        address _token,
        uint256 _tokenID,
        bytes calldata data
    ) external {
        //LibDMSGuards._onlyVaultOwner();
        LibTokens._safeInputERC721TokenAndCall(_token, _tokenID, data);
    }

    //WITHDRAWALS

    function withdrawERC721Token(
        address _token,
        uint256 _tokenID,
        address _to
    ) public {
        LibGuards._onlyVaultOwner();
        LibTokens._withdrawERC721Token(_token, _tokenID, _to);
    }

    //APPROVALS
    function approveSingleERC721Token(
        address _token,
        address _to,
        uint256 _tokenID
    ) external {
        LibGuards._onlyVaultOwner();
        LibTokens._approveERC721Token(_token, _tokenID, _to);
    }

    function approveAllERC721Token(
        address _token,
        address _to,
        bool _approved
    ) external {
        LibGuards._onlyVaultOwner();
        LibTokens._approveAllERC721Token(_token, _to, _approved);
    }

    //DEPOSIT COMPATIBILITY

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public pure returns (bytes4) {
        return ERC721WithCall;
    }
}
