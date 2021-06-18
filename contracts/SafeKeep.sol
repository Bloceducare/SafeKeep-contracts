//SPDX-License-Identifier: Unlicense
//2020 Safekeep Finance v1
pragma solidity ^0.8.0;

import "hardhat/console.sol";
//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';

contract SafeKeep is Ownable,ReentrancyGuard{
using SafeMath for uint256;
//using SafeERC20 for IERC20;

//_vaultType depicts if the vault is a premium vault or it is a free one
//0==free,//1==premium
//safekeepV1 Vaults will only support eth and erc20 tokens for now

struct Vault{
    address _owner;
    uint256 _weiBal;
    uint256  _lastPing;
    uint256 _id;
    uint8 _vaultType;
    address[] _inheritors;
    mapping(address=>uint256) _ownerTokenBalances;
    mapping(address=>uint256) _inheritorWeishares;
    mapping(address=>mapping(address=>uint)) _inheritorTokenShares;
    mapping(address=>bool) activeInheritors;
    
}


//using a central struct
struct SFStorage{
   Vault[] vaults;
   uint256 VAULT_ID;
   address _mediator;
   mapping(address=> bool) hasVault;
}

bytes32 private _contractIdentifier= keccak256(abi.encodePacked('SAFEKEEPV1'));
uint8 private vaultPlan=0; //0==free,//1==premium


mapping(address=>bool) public _whitelistedAssets;
//mapping(address=>Vault) public vaultIndex;
mapping(uint256=>Vault) public vaultDefaultIndex;
mapping(bytes32=> SFStorage) private contractStore;
//mapping(address=>(mapping()))
/**
modifier _hasMinTokenBalance(address owner_,address token_,uint256 _amount){
    require(vaultIndex[owner_]._ownerTokenBalances[token_]>=_amount,'Vault: Token Balance not Enough');
    _;
}

modifier premiumVault(uint id){
    
    require(vaultDefaultIndex[id]._vaultType==1,'Vault: vault is not premium,try upgrading');
    _;
}
**/


/**
modifier hasGivenAllowance(address[] calldata tokens_,uint256[] calldata _amounts){
    require(tokens_.length==_amounts.length,'TokenDeposit: number of tokens does not match number of amounts');
    for(uint256 i; i<tokens_.length;i++){
        IERC20 _t=IERC20(tokens_[i]);
        require(_t.allowance(msg.sender,address(this))>=_amounts[i],'TokenDeposit: you have not approved safekeep to spend your tokens');
        _;
    }
}
**/

modifier vaultOwner(uint vaultID){
    require(vaultDefaultIndex[vaultID]._owner==msg.sender,'vaultOwner: you are not the vault owner');
    _;
}  

modifier notExpired(uint vaultID){
    require(block.timestamp.sub(vaultDefaultIndex[vaultID]._lastPing)<24 weeks,'Has not expired yet');
    console.log('still has',block.timestamp.sub(vaultDefaultIndex[vaultID]._lastPing),'seconds left');
    _;
}


function createVault(address[] calldata inheritors,uint256 _startingBal) public payable returns(uint){
    require(msg.value==_startingBal,'CreateVault: Sent ether does not match inputted ether');
    SFStorage storage s=contractStore[_contractIdentifier];
    require(s.hasVault[msg.sender]==false,'you already have a vault');
    vaultDefaultIndex[s.VAULT_ID]._id=s.VAULT_ID;
    vaultDefaultIndex[s.VAULT_ID]._owner=msg.sender;
    vaultDefaultIndex[s.VAULT_ID]._weiBal+=_startingBal;
    vaultDefaultIndex[s.VAULT_ID]._inheritors=inheritors;
    vaultDefaultIndex[s.VAULT_ID]._vaultType=vaultPlan;//free by default
    vaultDefaultIndex[s.VAULT_ID]._lastPing=block.timestamp;
    s.hasVault[msg.sender]=true;//you now have a vault
    for(uint256 k;k<inheritors.length;k++){
        vaultDefaultIndex[s.VAULT_ID].activeInheritors[inheritors[k]]=true;//all inheritors are active by default
    }
    s.VAULT_ID++;
    return vaultDefaultIndex[s.VAULT_ID]._id;
    
  
    
}

function depositTokens(uint256 _id,address[] calldata tokenDeps, uint256[] calldata _amounts) external vaultOwner(_id) nonReentrant returns(address[] memory,uint[] memory){
   // Vault storage v=vaultDefaultIndex[_id];
   require(tokenDeps.length==_amounts.length,'TokenDeposit: number of tokens does not match number of amounts');
      for (uint256 j;j<tokenDeps.length;j++){
        IERC20 _j=IERC20(tokenDeps[j]);
        require(_j.allowance(msg.sender,address(this))>=_amounts[j],'TokenDeposit: you have not approved safekeep to spend your tokens');
        require(_j.transferFrom(msg.sender,address(this),_amounts[j]));
        vaultDefaultIndex[_id]._ownerTokenBalances[tokenDeps[j]]+=_amounts[j];
    }
    return(tokenDeps,_amounts);
}

  



}