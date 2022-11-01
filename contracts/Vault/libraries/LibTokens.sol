pragma solidity 0.8.4;

import {LibDMS} from "./LibDMS.sol";
import {IERC721} from "../../interfaces/IERC721.sol";
import {IERC1155} from "../../interfaces/IERC1155.sol";
import {IERC20} from "../../interfaces/IERC20.sol";
import {FacetAndSelectorData} from "../libraries/LibLayoutSilo.sol";
import {LibStorageBinder} from "../libraries/LibStorageBinder.sol";
import {LibModuleManager} from "../libraries/LibModuleManager.sol";
import {LibErrors} from "../libraries/LibErrors.sol";
import {LibDiamond} from "../libraries/LibDiamond.sol";

bytes4 constant ERC1155_ACCEPTED = 0xf23a6e61;
bytes4 constant ERC1155_BATCH_ACCEPTED = 0xbc197c81;
bytes4 constant ERC721WithCall = 0xb88d4fde;

    error InsufficientTokens();
        error NotERC721Owner();

//token deposit events might be deprecated since deposits can occur without any contract triggers for the vault
library LibTokens {

    event ErrorHandled(address);
    event ERC20ErrorHandled(address);
    event ERC721ErrorHandled(address);

    event ERC20TokenDeposit(address indexed token, address indexed from, uint256 amount, uint256 vaultID);
    event ERC20TokenWithdrawal(address token, uint256 amount, address to, uint256 vaultID);

    event ERC721TokenDeposit(address indexed token, address indexed from, uint256 tokenID, uint256 vaultID);
    event ERC721TokenWIthdrawal(address token, uint256 tokenID, address to, uint256 vaultID);

    event ERC1155TokenDeposit(
        address indexed token, address indexed from, uint256 tokenID, uint256 amount, uint256 vaultID
    );
    event ERC1155TokenWithdrawal(address token, uint256 tokenID, uint256 amount, address to, uint256 vaultID);

    event BatchERC1155TokenDeposit(
        address indexed token, address indexed from, uint256[] tokenIDs, uint256[] amounts, uint256 vaultID
    );

    //ERC20
    function _inputERC20Tokens(address[] calldata _tokenDeps, uint256[] calldata _amounts) internal {
        if (_tokenDeps.length == 0 || _amounts.length == 0) {
            revert LibErrors.EmptyArray();
        }
        if (_tokenDeps.length != _amounts.length) {
            revert LibErrors.LengthMismatch();
        }
        for (uint256 i; i < _tokenDeps.length; i++) {
            address token = _tokenDeps[i];
            uint256 amount = _amounts[i];
            bool success;
            try IERC20(token).transferFrom(msg.sender, address(this), amount) {
                success;
            } catch {
                if (success) {
                    emit ERC20TokenDeposit(token, msg.sender, amount, LibDiamond.vaultID());
                } else {
                    emit ErrorHandled(token);
                    continue;
                }
            }
        }
    }

    function _inputERC20Token(address _token, uint256 _amount) internal {
        assert(IERC20(_token).transferFrom(msg.sender, address(this), _amount));
        emit ERC20TokenDeposit(_token, msg.sender, _amount, LibDiamond.vaultID());
    }

    function _approveERC20Token(address _spender, address _token, uint256 _amount) internal {
        IERC20(_token).approve(_spender, _amount);
                //ping if DMS is installed
        if(LibModuleManager._isActiveModule("DMS")){
    LibDMS._ping();
}
    }

    function _withdrawERC20Token(address _token, uint256 _amount, address _to) internal {
    uint256 availableTokens;
uint256 currentBalance = IERC20(_token).balanceOf(address(this));
//check if DMS module is installed
//also ping if DMS is installed
if(LibModuleManager._isActiveModule("DMS")){
    if(currentBalance > LibDMS.getCurrentAllocatedTokens(_token)){
    availableTokens=currentBalance - LibDMS.getCurrentAllocatedTokens(_token);
    LibDMS._ping();
}
else{
    revert InsufficientTokens();
}
}
else{
    availableTokens=currentBalance;
}
        bool success;
        if (currentBalance >= availableTokens) {
            if (currentBalance - availableTokens < _amount) {
                revert InsufficientTokens();
            }
            try IERC20(_token).transfer(_to, _amount) {
                success;
            } catch {
                if (success) {
                    emit ERC20TokenWithdrawal(_token, _amount, _to, LibDiamond.vaultID());
                } else {
                    emit ERC20ErrorHandled(_token);
                }
            }
        } else {
            revert InsufficientTokens();
        }
    }


    function _withdrawERC20Tokens(address[] calldata _tokenAdds, uint256[] calldata _amounts, address _to) internal {
        if (_tokenAdds.length == 0 || _amounts.length == 0) {
            revert LibErrors.EmptyArray();
        }
        if (_tokenAdds.length != _amounts.length) {
            revert LibErrors.LengthMismatch();
        }
        for (uint256 x; x < _tokenAdds.length; x++) {
            address token = _tokenAdds[x];
            uint256 amount = _amounts[x];
             uint256 currentBalance = IERC20(token).balanceOf(address(this));
             uint256 availableTokens;
             if(LibModuleManager._isActiveModule("DMS")){
uint256 allocated=LibDMS.getCurrentAllocatedTokens(token);
                if(currentBalance >allocated ){
    availableTokens=currentBalance - allocated;
    LibDMS._ping();
}
else{
    revert InsufficientTokens();
}
             }

else{
    availableTokens=currentBalance;
}   
            bool success;
            if (currentBalance >= availableTokens) {
                if (currentBalance - availableTokens < _amounts[x]) {
                    revert InsufficientTokens();
                }
                //for other errors caused by malformed tokens
                try IERC20(token).transfer(_to, amount) {
                    success;
                } catch {
                    if (success) {
                        emit ERC20TokenWithdrawal(token, amount, _to, LibDiamond.vaultID());
                    } else {
                        emit ERC20ErrorHandled(token);
                    }
                }
            } else {
                revert InsufficientTokens();
            }
        
    }
    }

    //ERC721
    function _inputERC721Token(address _token, uint256 _tokenID) internal {
       
        IERC721(_token).transferFrom(msg.sender, address(this), _tokenID);
        emit ERC721TokenDeposit(_token, msg.sender, _tokenID, LibDiamond.vaultID());
    }

    function _safeInputERC721Token(address _token, uint256 _tokenID) internal {
     
        IERC721(_token).safeTransferFrom(msg.sender, address(this), _tokenID);
        emit ERC721TokenDeposit(_token, msg.sender, _tokenID, LibDiamond.vaultID());
    }

    function _safeInputERC721TokenAndCall(address _token, uint256 _tokenID, bytes calldata _data) internal {
     
        IERC721(_token).safeTransferFrom(msg.sender, address(this), _tokenID, _data);
    }

    function _approveERC721Token(address _token, uint256 _tokenID, address _to) internal {
     
        IERC721(_token).approve(_to, _tokenID);
    }

    function _approveAllERC721Token(address _token, address _to, bool _approved) internal {
     
        IERC721(_token).setApprovalForAll(_to, _approved);
    }

     function _withdrawERC721Token(address _token, uint256 _tokenID, address _to) internal {
        if (IERC721(_token).ownerOf(_tokenID) != address(this)) {
            revert NotERC721Owner();
        }
         if(LibModuleManager._isActiveModule("DMS")){
      if(LibDMS._isERC721Allocated(_token,_tokenID))
            revert("UnAllocate Token First");
            LibDMS._ping();
        }
        try IERC721(_token).safeTransferFrom(address(this), _to, _tokenID) {}
        catch {
            string memory reason;
            if (bytes(reason).length == 0) {
                emit ERC721TokenWIthdrawal(_token, _tokenID, _to, LibDiamond.vaultID());
            } else {
                emit ERC721ErrorHandled(_token);
            }
        }
    }

    //ERC1155

    function _safeInputERC1155Token(address _token, uint256 _tokenID, uint256 _value) internal {
     
        IERC1155(_token).safeTransferFrom(msg.sender, address(this), _tokenID, _value, "");
        emit ERC1155TokenDeposit(_token, msg.sender, _tokenID, _value, LibDiamond.vaultID());
    }

    function _safeBatchInputERC1155Tokens(address _token, uint256[] calldata _tokenIDs, uint256[] calldata _values)
        internal
    {
     
        IERC1155(_token).safeBatchTransferFrom(msg.sender, address(this), _tokenIDs, _values, "");
        emit BatchERC1155TokenDeposit(_token, msg.sender, _tokenIDs, _values, LibDiamond.vaultID());
    }

    function _approveAllERC1155Token(address _token, address _to, bool _approved) internal {
     
        IERC1155(_token).setApprovalForAll(_to, _approved);
    }


    function _withdrawERC1155Token(address _token, uint256 _tokenID, uint256 _amount, address _to) internal {
         uint256 currentBalance = IERC1155(_token).balanceOf(address(this), _tokenID);
          uint256 availableTokens;
if(LibModuleManager._isActiveModule("DMS")){
 uint256 allocated=LibDMS.getCurrentAllocated1155tokens(_token, _tokenID);
    if(currentBalance>allocated){
availableTokens=currentBalance-allocated;
LibDMS._ping();
    }
     if (currentBalance < _amount) {
            revert InsufficientTokens();
        }

        if (currentBalance - allocated < _amount) {
            revert("UnAllocate TokensFirst");
        }


}
else{
    availableTokens=currentBalance;
}

if(availableTokens<_amount){
    revert InsufficientTokens();
}

        IERC1155(_token).safeTransferFrom(address(this), _to, _tokenID, _amount, "");
        emit ERC1155TokenWithdrawal(_token, _tokenID, _amount, _to, LibDiamond.vaultID());
    
}

}