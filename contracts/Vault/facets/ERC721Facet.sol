pragma solidity 0.8.4;

import "../libraries/LibKeep.sol";

import "../libraries/LibTokens.sol";

import "../libraries/LibLayoutSilo.sol";
import "../libraries/LibStorageBinder.sol";

contract ERC721Facet  {


 struct AllocatedERC721Tokens{
    address token;
    uint256[] tokenIDs;
 }

 function getAllocatedERC721Tokens(address _inheritor) public view returns(AllocatedERC721Tokens[] memory allocated){
   VaultData storage vaultData=LibStorageBinder._bindAndReturnVaultStorage();
    Guards._activeInheritor(_inheritor);
    uint256 tokenAddressCount=vaultData.inheritorAllocatedERC721TokenAddresses[_inheritor].length;
    if(tokenAddressCount>0){
        allocated=new AllocatedERC721Tokens[](tokenAddressCount);
        for(uint256 i; i < tokenAddressCount; i++){
            address _token=vaultData.inheritorAllocatedERC721TokenAddresses[_inheritor][i];
            allocated[i].token=_token;
            allocated[i].tokenIDs=vaultData.inheritorAllocatedTokenIds[_inheritor][_token];
        }
    }
 }  

 function getAllocatedERC721TokenIds(address _inheritor,address _token) external view returns(uint256[] memory){
     VaultData storage vaultData=LibStorageBinder._bindAndReturnVaultStorage();
    Guards._activeInheritor(_inheritor);
    return vaultData.inheritorAllocatedTokenIds[_inheritor][_token];
 }
 function getAllocatedERC721TokenAddresses(address _inheritor) public view returns(address[] memory){
   VaultData storage vaultData=LibStorageBinder._bindAndReturnVaultStorage();
   Guards._activeInheritor(_inheritor);
   return vaultData.inheritorAllocatedERC721TokenAddresses[_inheritor];
 }

  //DEPOSITS

   function depositERC721Token(
    address _token,
    uint256 _tokenID
  ) external {
   // Guards._onlyVaultOwner();
    LibTokens._inputERC721Token(_token, _tokenID);
  }

  function depositERC721Tokens(address _token,uint256[] calldata _tokenIDs) external{
    for(uint256 i;i<_tokenIDs.length;i++){
      LibTokens._inputERC721Token(_token,_tokenIDs[i]);
    }
  }

   function safeDepositERC721Token(
    address _token,
    uint256 _tokenID
  ) external {
   // Guards._onlyVaultOwner();
    LibTokens._safeInputERC721Token(_token, _tokenID);
  }



   function safeDepositERC721TokenAndCall(
    address _token,
    uint256 _tokenID,bytes calldata data
  ) external {
    //Guards._onlyVaultOwner();
    LibTokens._safeInputERC721TokenAndCall(_token, _tokenID,data);
  }


  //WITHDRAWALS

   function withdrawERC721Token(
    address _token,
    uint256 _tokenID,
    address _to
  ) public {
    Guards._onlyVaultOwner();
    LibKeep._withdrawERC721Token(_token, _tokenID, _to);
  }

//APPROVALS
  function approveSingleERC721Token(
    address _token,
    address _to,
    uint256 _tokenID
  ) external {
    Guards._onlyVaultOwner();
    LibTokens._approveERC721Token(_token, _tokenID,_to);
  }

function approveAllERC721Token(address _token,address _to,bool _approved) external {
    Guards._onlyVaultOwner();
    LibTokens._approveAllERC721Token(_token,_to,_approved);
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