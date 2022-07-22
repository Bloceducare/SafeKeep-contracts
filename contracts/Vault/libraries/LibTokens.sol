pragma solidity 0.8.4;

import "./LibKeep.sol";
import "../../interfaces/IERC721.sol";
import "../../interfaces/IERC1155.sol";

library LibTokens {
  event ErrorHandled(string);

  event ERC20TokenDeposit(
    address indexed token,
    address indexed from,
    uint256 amount,
    uint256 vaultID
  );

  event ERC721TokenDeposit(
    address indexed token,
    address indexed from,
    uint256 tokenID,
    uint256 vaultID
  );

  event ERC1155TokenDeposit(
    address indexed token,
    address indexed from,
    uint256 tokenID,
    uint256 amount,
    uint256 vaultID
  );

  event BatchERC1155TokenDeposit(
     address indexed token,
    address indexed from,
    uint256[] tokenIDs,
    uint256[] amounts,
    uint256 vaultID 
  );

  //ERC20
  function _inputERC20Tokens(
    address[] calldata _tokenDeps,
    uint256[] calldata _amounts
  ) internal {
    Guards._notExpired();
    if (_tokenDeps.length == 0 || _amounts.length == 0)
      revert LibKeep.EmptyArray();
    if (_tokenDeps.length != _amounts.length) revert LibKeep.LengthMismatch();
    for (uint256 i; i < _tokenDeps.length; i++) {
      address token = _tokenDeps[i];
      uint256 amount = _amounts[i];
      bool success;
      try IERC20(token).transferFrom(msg.sender, address(this), amount) {
        success;
      } catch {
        //assumes all ERC20 errors have a revert string
        string memory reason;
        if (success) {
          emit ERC20TokenDeposit(token, msg.sender, amount, LibKeep._vaultID());
        } else {
          emit ErrorHandled(reason);
          continue;
        }
      }
    }
    LibKeep._ping();
  }

  function _inputERC20Token(address _token, uint256 _amount) internal {
    Guards._notExpired();
    //   bool success;
    assert(IERC20(_token).transferFrom(msg.sender, address(this), _amount));
    emit ERC20TokenDeposit(_token, msg.sender, _amount, LibKeep._vaultID());
    LibKeep._ping();
  }

  function _approveERC20Token(
    address _spender,
    address _token,
    uint256 _amount
  ) internal {
    IERC20(_token).approve(_spender, _amount);
  }

  //ERC721
  function _inputERC721Token(address _token, uint256 _tokenID) internal {
    Guards._notExpired();
    IERC721(_token).transferFrom(msg.sender, address(this), _tokenID);
    emit ERC721TokenDeposit(_token,msg.sender,_tokenID,LibKeep._vaultID());
  }

  function _safeInputERC721Token(address _token, uint256 _tokenID) internal {
    Guards._notExpired();
    IERC721(_token).safeTransferFrom(msg.sender, address(this), _tokenID);
    emit ERC721TokenDeposit(_token,msg.sender,_tokenID,LibKeep._vaultID());
  }

  function _safeInputERC721TokenAndCall(
    address _token,
    uint256 _tokenID,
    bytes calldata _data
  ) internal {
    Guards._notExpired();
    IERC721(_token).safeTransferFrom(
      msg.sender,
      address(this),
      _tokenID,
      _data
    );
  }

  function _approveERC721Token(
    address _token,
    uint256 _tokenID,
    address _to
  ) internal {
    Guards._notExpired();
    IERC721(_token).approve(_to, _tokenID);
  }

  function _approveAllERC721Token(
    address _token,
    address _to,
    bool _approved
  ) internal {
    Guards._notExpired();
    IERC721(_token).setApprovalForAll(_to, _approved);
  }

  //ERC1155

  function _safeInputERC1155Token(
    address _token,
    uint256 _tokenID,
    uint256 _value
  ) internal {
    Guards._notExpired();
    IERC1155(_token).safeTransferFrom(
      msg.sender,
      address(this),
      _tokenID,
      _value,
      ""
    );
      emit ERC1155TokenDeposit(_token,msg.sender,_tokenID,_value,LibKeep._vaultID());
  }

  function _safeBatchInputERC1155Tokens(
    address _token,
    uint256[] calldata _tokenIDs,
    uint256[] calldata _values
  ) internal {
    Guards._notExpired();
    IERC1155(_token).safeBatchTransferFrom(
      msg.sender,
      address(this),
      _tokenIDs,
      _values,
      ""
    );
     emit BatchERC1155TokenDeposit(_token,msg.sender,_tokenIDs,_values,LibKeep._vaultID());
  }

  function _approveAllERC1155Token(
    address _token,
    address _to,
    bool _approved
  ) internal {
    Guards._notExpired();
    IERC1155(_token).setApprovalForAll(_to, _approved);
  }
}
