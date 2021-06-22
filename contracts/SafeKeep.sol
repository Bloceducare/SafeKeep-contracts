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

//safekeepV1 Vaults will only support eth and erc20 tokens for now

struct Vault{
    address _owner;
    uint256 _VAULT_WEI_BALANCE;
    uint256  _lastPing;
    uint256 _id;
    address backup;
    address[] _inheritors;
    address[] tokensDeposited;
    mapping(address=>uint256) _VAULT_TOKEN_BALANCES;     
    mapping(address=>uint256) _inheritorWeishares;
    mapping(address=>mapping(address=>uint)) _inheritorTokenShares;
    mapping(address=>bool) activeInheritors;
    mapping(address=> address[]) inheritorAllocatedTokens; 
} 

struct tokenAllocs{
    address token;
    uint256 amount;
    
}

struct allInheritorTokenAllocs{
    address inheritor_;
    address token_;
    uint256 amount_;
}

struct allInheritorEtherAllocs{
    address inheritor_;
    uint256 weiAlloc_;
}

struct tokenBal{
    address token_;
    uint256 bal_;
}


//using a central struct
struct SFStorage{
   //Vault[] vaults;
   uint256 VAULT_ID;
   address _mediator;
   mapping(address=> bool) hasVault;
}

bytes32 private _contractIdentifier= keccak256(abi.encodePacked('SAFEKEEPV1'));


mapping(address=>bool) public _whitelistedAssets;
mapping(uint256=>Vault) public vaultDefaultIndex;
mapping(bytes32=> SFStorage) private contractStore;

modifier vaultOwner(uint vaultID){
    require(vaultDefaultIndex[vaultID]._owner==msg.sender,'vaultOwner: you are not the vault owner');
    _;
} 

modifier vaultBackup(uint vaultID){
    require(vaultDefaultIndex[vaultID].backup==msg.sender,'vaultBackup: you are not the vault backup address');
    _;
}  

modifier notExpired(uint vaultID){
    require(block.timestamp.sub(vaultDefaultIndex[vaultID]._lastPing)<=24 weeks,'Has expired');
    console.log('still has',block.timestamp.sub(vaultDefaultIndex[vaultID]._lastPing),'seconds left');
    _;
}

receive() external payable {
    }


///////////////////
//VIEW FUNCTIONS//
/////////////////

function checkAllTokenAllocations(uint256 _vaultId) public view returns(tokenAllocs[] memory tAllocs){
    Vault storage v=vaultDefaultIndex[_vaultId];
    require(v.inheritorAllocatedTokens[msg.sender].length>0,'ClaimTokens: you do not have any allocated tokens in this vault');
    uint256 count=v.inheritorAllocatedTokens[msg.sender].length;
    tAllocs=new tokenAllocs[](count);
    for(uint256 i;i<count;i++){
      address _t=v.inheritorAllocatedTokens[msg.sender][i];
      tAllocs[i].amount=v._inheritorTokenShares[msg.sender][_t];
      tAllocs[i].token=_t;
    }
}

function checkAllEtherAllocations(uint256 _vaultId) public view returns(allInheritorEtherAllocs[] memory eAllocs){
    Vault storage v=vaultDefaultIndex[_vaultId];
    require(v._owner!=address(0),'Vault has not been created yet');
    uint256 inheritorCount=v._inheritors.length;
    eAllocs=new allInheritorEtherAllocs[](inheritorCount);
    for(uint256 i;i<inheritorCount;i++){
        eAllocs[i].inheritor_=v._inheritors[i];
        eAllocs[i].weiAlloc_=v._inheritorWeishares[v._inheritors[i]];
    }
} 

function checkEtherAllocation(uint256 _vaultId) public view returns(uint256 _allocated){
    Vault storage v=vaultDefaultIndex[_vaultId];
    require(v._inheritorWeishares[msg.sender]>0,'ClaimTokens: you do not have any allocated ether in this vault');
    _allocated=v._inheritorWeishares[msg.sender];
}

function checkAllAllocatedTokens(uint256 _vaultId) public view returns(allInheritorTokenAllocs[] memory allTokenAllocs){
    Vault storage v=vaultDefaultIndex[_vaultId];
    require(v._owner!=address(0),'Vault has not been created yet');
    uint256 inheritorCount=v._inheritors.length;
    allTokenAllocs=new allInheritorTokenAllocs[](inheritorCount);
    for(uint256 i;i<inheritorCount;i++){
        allTokenAllocs[i].inheritor_=v._inheritors[i];
        for(uint256 j;j<v.inheritorAllocatedTokens[allTokenAllocs[i].inheritor_].length;j++){
            uint256 _bal=v._inheritorTokenShares[msg.sender][v.inheritorAllocatedTokens[msg.sender][j]];
            address _tok=v.inheritorAllocatedTokens[msg.sender][j];
            allTokenAllocs[i].amount_=_bal;
            allTokenAllocs[i].token_=_tok;
        }
    }
}


function checkAllVaultTokenBalances(uint256 _vaultId) public view returns(tokenBal[] memory _tBal){
    Vault storage v=vaultDefaultIndex[_vaultId];
    for(uint256 k;k<v.tokensDeposited.length;k++){
        _tBal[k].bal_=v._VAULT_TOKEN_BALANCES[v.tokensDeposited[k]];
        _tBal[k].token_=v.tokensDeposited[k];
    }
    
}

function getAllInheritors(uint256 _vaultId) public view returns(address[] memory inheritors_){
    inheritors_=vaultDefaultIndex[_vaultId]._inheritors;
}


//////////////////////
///WRITE FUNCTIONS///
////////////////////
function createVault(address[] calldata inheritors,uint256 _startingBal,address _backupAddress) public payable returns(uint){
    require(msg.value==_startingBal,'CreateVault: Sent ether does not match inputted ether');
    SFStorage storage s=contractStore[_contractIdentifier];
    require(s.hasVault[msg.sender]==false,'you already have a vault');
    vaultDefaultIndex[s.VAULT_ID]._id=s.VAULT_ID;
    vaultDefaultIndex[s.VAULT_ID]._owner=msg.sender;
    vaultDefaultIndex[s.VAULT_ID]._VAULT_WEI_BALANCE=_startingBal;
   // vaultDefaultIndex[s.VAULT_ID]._OWNER_WEI_SHARE=_startingBal; //allocate all ether to owner
    vaultDefaultIndex[s.VAULT_ID]._inheritors=inheritors;
    vaultDefaultIndex[s.VAULT_ID]._lastPing=block.timestamp;
    vaultDefaultIndex[s.VAULT_ID].backup=_backupAddress;
    s.hasVault[msg.sender]=true;//you now have a vault
    for(uint256 k;k<inheritors.length;k++){
        vaultDefaultIndex[s.VAULT_ID].activeInheritors[inheritors[k]]=true;//all new inheritors are active by default
    }
    s.VAULT_ID++;
    return vaultDefaultIndex[s.VAULT_ID]._id;
    
  
    
}

function addInheritors(uint256 _vaultId,address[] calldata _newInheritors,uint256[] calldata _weiShare) external notExpired(_vaultId) returns(address[] memory, uint256[] memory){
    Vault storage v=vaultDefaultIndex[_vaultId];
    require(msg.sender==v._owner,'AddInheritors:you are not the vault owner');
    require(_newInheritors.length==_weiShare.length,'AddInheritors: Length of arguments do not match');
    uint256 _total;
    uint256 _existingallocated=getCurrentAllocatedEth(_vaultId);
    for(uint256 k;k<_newInheritors.length;k++){
         _total+=_weiShare[k];
        require(v.activeInheritors[_newInheritors[k]]==false,'AddInheritors: one or more of the addresses is already an active inheritor');
        require((_total.add(_existingallocated))<=v._VAULT_WEI_BALANCE,'AddInheritors:you do not have that much ether to allocate,unallocate or deposit more ether');
        v._inheritorWeishares[_newInheritors[k]]=_weiShare[k];
        //append the inheritors for a vault
        (v._inheritors).push(_newInheritors[k]);
        v.activeInheritors[_newInheritors[k]]=true;
    }
    _ping(_vaultId);
    return(_newInheritors,_weiShare); 
}

function removeInheritors(uint256 _vaultId,address[] calldata _inheritors) external notExpired(_vaultId) returns(address[] memory ){
    Vault storage v=vaultDefaultIndex[_vaultId];
    require(msg.sender==v._owner,'activateInheritors:you are not the vault owner');
    for(uint256 k;k<_inheritors.length;k++){
        require(v.activeInheritors[_inheritors[k]]==true,'activateInheritors:one or more inheritor is already removed or does not exist');
        v.activeInheritors[_inheritors[k]]=false;
        //pop out the address from the array
        removeAddress(v._inheritors,_inheritors[k]);
        reset(_vaultId,_inheritors[k]);
    }
    _ping(_vaultId);
    return _inheritors;
    
}

function depositEther(uint256 _vaultId,uint256 _amount) external payable vaultOwner(_vaultId) notExpired(_vaultId) nonReentrant returns(uint currentEtherBalance){
    Vault storage v=vaultDefaultIndex[_vaultId];
    require(_amount==msg.value,'DepositEther:Amount sent does not equal amount entered');
    v._VAULT_WEI_BALANCE+=_amount;
    _ping(_vaultId);
    return v._VAULT_WEI_BALANCE;
}

function depositTokens(uint256 _id,address[] calldata tokenDeps, uint256[] calldata _amounts) external vaultOwner(_id) notExpired(_id) nonReentrant returns(address[] memory,uint256[] memory){
    Vault storage v=vaultDefaultIndex[_id];
   require(tokenDeps.length==_amounts.length,'TokenDeposit: number of tokens does not match number of amounts');
      for (uint256 j;j<tokenDeps.length;j++){
        IERC20 _j=IERC20(tokenDeps[j]);
        require(_j.allowance(msg.sender,address(this))>=_amounts[j],'TokenDeposit: you have not approved safekeep to spend one or more of your tokens');
        require(_j.transferFrom(msg.sender,address(this),_amounts[j]));
        v._VAULT_TOKEN_BALANCES[tokenDeps[j]]+=_amounts[j];
        v.tokensDeposited.push(tokenDeps[j]);
    }
    _ping(_id);
    return(tokenDeps,_amounts);
}

function allocateTokens(uint256 _vaultId,address tokenAdd,address[] calldata _inheritors,uint256[] calldata _shares) external nonReentrant returns(address[] memory,uint256[] memory){
    Vault storage v=vaultDefaultIndex[_vaultId];
    require(msg.sender==v._owner,'AllocateTokens:you are not the vault owner');
    require(_inheritors.length==_shares.length,'AllocateTokens: Length of arguments do not match');
    uint256 _total=0;
    uint existingAllocated;
    for(uint256 k;k<_inheritors.length;k++){
        _total+=_shares[k];
        existingAllocated=getCurrentAllocatedTokens(_vaultId,tokenAdd);
        require(_total<=v._VAULT_TOKEN_BALANCES[tokenAdd],'AllocateTokens: you do not have that much tokens to allocate,unallocate or deposit more tokens');
        require(v.activeInheritors[_inheritors[k]]==true,'AllocateTokens: one of the addresses is not an active inheritor');
        v._inheritorTokenShares[tokenAdd][_inheritors[k]]=_shares[k];
        v.inheritorAllocatedTokens[_inheritors[k]].push(tokenAdd);
        //v._ownerTokenBalances[tokenAdd]-=_shares[k]; //reduce vault owner allocation
    }
    _ping(_vaultId);
 return (_inheritors,_shares);   
}

function allocateEther(uint256 _vaultId,address[] calldata _inheritors,uint256[] calldata _ethShares) external nonReentrant returns(address[] memory,uint256[] memory){
    Vault storage v=vaultDefaultIndex[_vaultId];
    require(msg.sender==v._owner,'AllocateEther:you are not the vault owner');
    require(_inheritors.length==_ethShares.length,'AllocateEther: Length of arguments do not match');
    uint256 _total=0;
  //  uint256 _allocated=getCurrentAllocatedEth(_vaultId);
    for(uint256 k;k<_inheritors.length;k++){
        _total+=_ethShares[k];
        require(_total<=v._VAULT_WEI_BALANCE,'AllocateEther: you do not have that much Ether to allocate,unallocate or deposit more ether');
        require(v.activeInheritors[_inheritors[k]]==true,'AllocateEther: one of the addresses is not an active inheritor');
        v._inheritorWeishares[_inheritors[k]]=_ethShares[k];
     //   v._OWNER_WEI_SHARE-=_ethShares[k];
    }
    _ping(_vaultId);
    return(_inheritors,_ethShares);
    
}

function checkEthLimit(uint256 _vaultId) internal view returns(uint256 _unallocated){
     Vault storage v=vaultDefaultIndex[_vaultId];
     uint256 totalEthAllocated;
        for(uint256 x;x<v._inheritors.length;x++){
            totalEthAllocated+=v._inheritorWeishares[v._inheritors[x]];
        }
        require(v._VAULT_WEI_BALANCE>=totalEthAllocated,'WEI:Overflow, unallocate some ether');
        return v._VAULT_WEI_BALANCE.sub(totalEthAllocated);
}

function checkTokenLimit(uint256 _vaultId,address token) internal view returns(uint256 _unallocated){
    Vault storage v=vaultDefaultIndex[_vaultId];
    uint256 totalTokensAllocated;
    for(uint256 x;x<v._inheritors.length;x++){
        totalTokensAllocated+=v._inheritorTokenShares[v._inheritors[x]][token];
    }
    require(v._VAULT_TOKEN_BALANCES[token]>=totalTokensAllocated,'TOKEN: Overflow, unallocate some tokens');
    return v._VAULT_TOKEN_BALANCES[token].sub(totalTokensAllocated);
}


function findAddIndex(address _item,address[] memory addressArray) public pure returns(uint i){
      for( i;i<addressArray.length;i++){
        //using the conventional method since we cannot have duplicate addresses
        if(addressArray[i]==_item){
            return i;
        }
    }
}
function removeAddress(address[] storage _array,address _add)internal{
    uint index=findAddIndex(_add,_array);
    for(uint256 i=index;i<_array.length;i++){
        _array[i]=_array[i+1];
    }
    _array.pop();
}

function reset(uint _vaultId,address _inheritor) internal returns(uint unAllocatedWei){
    Vault storage v=vaultDefaultIndex[_vaultId];
    unAllocatedWei=v._inheritorWeishares[_inheritor];
    v._inheritorWeishares[_inheritor]=0;
    //resetting all token allocations
    for(uint256 x;x<v.inheritorAllocatedTokens[_inheritor].length;x++){
        v._inheritorTokenShares[v.inheritorAllocatedTokens[_inheritor][x]][_inheritor]=0;
    }
    //remove all token addresses
    delete v.inheritorAllocatedTokens[_inheritor];
}  
 
function getCurrentAllocatedEth(uint256 _vaultId) internal view returns(uint256){
    Vault storage v=vaultDefaultIndex[_vaultId];
    uint totalEthAllocated;
    for(uint256 x;x<v._inheritors.length;x++){
    totalEthAllocated+=v._inheritorWeishares[v._inheritors[x]];
    }
    return totalEthAllocated;
}

function getCurrentAllocatedTokens(uint256 _vaultId,address _token) internal view returns(uint256){
    Vault storage v=vaultDefaultIndex[_vaultId];
    uint totalTokensAllocated;
    for(uint256 x;x<v._inheritors.length;x++){
    totalTokensAllocated+=v._inheritorTokenShares[v._inheritors[x]][_token];
    }
    return totalTokensAllocated;
}

function withdrawEth(uint256 _vaultId,uint256 _amount) public vaultOwner(_vaultId) nonReentrant returns(uint){
    Vault storage v=vaultDefaultIndex[_vaultId];
    uint256 _avail=v._VAULT_WEI_BALANCE.sub(getCurrentAllocatedEth(_vaultId));
    require(_amount<=_avail,'withdrawEth: Not enough eth, Unallocate from some inheritors or deposit more');
    //reduce balance after checks
    v._VAULT_WEI_BALANCE.sub(_amount);
    payable(v._owner).transfer(_amount);
    _ping(_vaultId);
    return(v._VAULT_WEI_BALANCE);
}

function withdrawTokens(uint256 _vaultId,address[] calldata tokenAdds,uint256[] calldata _amounts) public vaultOwner(_vaultId) nonReentrant returns(bool){
    Vault storage v=vaultDefaultIndex[_vaultId];
    for(uint256 x;x<tokenAdds.length;x++){
    uint  _availableTokens=v._VAULT_TOKEN_BALANCES[tokenAdds[x]].sub(getCurrentAllocatedTokens(_vaultId,tokenAdds[x]));
    require(_availableTokens>=_amounts[x],'withdrawToken:Not enough tokens, unallocate from some inheritors or deposit more');
    //transfer tokens after checks then reduce balance
    IERC20 _j=IERC20(tokenAdds[x]);
    require(_j.transfer(v._owner,_amounts[x]));
    v._VAULT_TOKEN_BALANCES[tokenAdds[x]].sub(_amounts[x]);
    //if no tokens remain,delete the array
        if (v._VAULT_TOKEN_BALANCES[tokenAdds[x]]==0){
            removeAddress(v.tokensDeposited,tokenAdds[x]);
        }
    
    }
    _ping(_vaultId);
    return true;
}

function _ping(uint256 _vaultId) private vaultOwner(_vaultId) returns(uint256){
    vaultDefaultIndex[_vaultId]._lastPing=block.timestamp;
    return(vaultDefaultIndex[_vaultId]._lastPing);
}

function ping(uint256 _vaultId) external {
    _ping(_vaultId);
}

//////////
//DANGER//
/////////
function transferOwner(uint256 _vaultId,address _newOwner) public vaultOwner(_vaultId) returns(address){
    vaultDefaultIndex[_vaultId]._owner=_newOwner;
    _ping(_vaultId);
    return _newOwner;
}

function transferBackup(uint256 _vaultId,address _newBackup) public vaultBackup(_vaultId) returns(address){
    vaultDefaultIndex[_vaultId].backup=_newBackup;
    return _newBackup;
}

function claimOwnership(uint256 _vaultId,address _backup) public vaultBackup(_vaultId) returns(address){
    require(block.timestamp.sub(vaultDefaultIndex[_vaultId]._lastPing)>24 weeks,'Has not expired');
    vaultDefaultIndex[_vaultId]._owner=msg.sender;
    vaultDefaultIndex[_vaultId].backup=_backup;
    return msg.sender;
}
//////////
//CLAIMS//
//////////
function claimAllTokens(uint256 _vaultId) internal nonReentrant{
    Vault storage v=vaultDefaultIndex[_vaultId];
    require(block.timestamp.sub(v._lastPing)>24 weeks,'Has not expired');
    require(v.inheritorAllocatedTokens[msg.sender].length>0,'ClaimTokens: you do not have any allocated tokens in this vault');
    for(uint256 i;i<v.inheritorAllocatedTokens[msg.sender].length;i++){
        IERC20 _t=IERC20(v.inheritorAllocatedTokens[msg.sender][i]);
        require(_t.transfer(msg.sender,v._inheritorTokenShares[msg.sender][v.inheritorAllocatedTokens[msg.sender][i]]));
    }
    removeAddress(v._inheritors,msg.sender);
    reset(_vaultId,msg.sender);
}

function claimEth(uint256 _vaultId) public returns(uint256){
    Vault storage v=vaultDefaultIndex[_vaultId];
    require(block.timestamp.sub(v._lastPing)>24 weeks,'Has not expired');
    require(v._inheritorWeishares[msg.sender]>0,'ClaimEth: you do not have allocated eth this vault');
    uint256 _toClaim=v._inheritorWeishares[msg.sender];
    //reset balance
    v._inheritorWeishares[msg.sender]=0;
    v._VAULT_WEI_BALANCE.sub(_toClaim);
    //send out balance
    payable(msg.sender).transfer(_toClaim);
    claimAllTokens(_vaultId);
    return _toClaim;
}





}