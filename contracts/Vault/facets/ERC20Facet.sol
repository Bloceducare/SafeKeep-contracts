pragma solidity 0.8.4;

import {LibTokens} from "../libraries/LibTokens.sol";

import "../libraries/LibLayoutSilo.sol";
import "../libraries/LibStorageBinder.sol";

import {LibGuards} from "../libraries/LibGuards.sol";

contract ERC20Facet {
    //DEPOSITS
    /// @notice deposits ERC20 token into the vault
    function depositERC20Token(address _token, uint256 _amount) external {
        //  LibGuards._onlyVaultOwner();
        LibTokens._inputERC20Token(_token, _amount);
    }

    /// @notice deposits multiple ERC20 tokens into the vault
    function depositERC20Tokens(address[] calldata _tokens, uint256[] calldata _amounts) external {
        //LibGuards._onlyVaultOwner();
        LibTokens._inputERC20Tokens(_tokens, _amounts);
    }

    //WITHDRAWALS
    /// @notice withdraws an ERC20 token from the vault
    function withdrawERC20Token(address _token, uint256 _amount, address _to) public {
        LibGuards._onlyVaultOwner();
        LibTokens._withdrawERC20Token(_token, _amount, _to);
    }
    /// @notice allows caller to withdraw multiple ERC20 tokens from the vault
    function batchWithdrawERC20Token(address[] calldata _tokens, uint256[] calldata _amounts, address _to) public {
        LibGuards._onlyVaultOwner();
        LibTokens._withdrawERC20Tokens(_tokens, _amounts, _to);
    }

    //APPROVALS
    /// @notice approves an ERC20 token to be spent by _to
    function approveERC20Token(address _token, address _to, uint256 _amount) external {
        LibGuards._onlyVaultOwner();
        LibTokens._approveERC20Token(_token, _to, _amount);
    }
}
