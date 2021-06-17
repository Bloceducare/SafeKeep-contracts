//SPDX-License-Identifier: Unlicense
//2020 Safekeep Finance
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';

contract SafeKeep is Ownable{
using SafeMath for uint256;
using SafeERC20 for IERC20;

//_vaultType depicts if the vault is a premium vault or it is a free one
//0==free,//1==premium
struct Vault{
    address _owner;
    uint256 _weiBal;
    uint256  _lastPing;
    address[] _inheritors;
    uint8 _vaultType;
    mapping(address=>uint256) _tokenBalances;
}

address public _mediator;
mapping(address=>bool) public _whitelistedAssets;
mapping(address=>Vault) private vaultIndex;

modifier _hasMinTokenBalance(address owner_,address token_,uint256 _amount){
    require(vaultIndex[owner_]._tokenBalances[token_]>=_amount,'Vault: Token Balance not Enough');
    _;
}

modifier premiumVault(address _vaultowner){
    require(vaultIndex[_vaultowner]._vaultType==1,'Vault: vault is not premium,try upgrading');
    _;
}

modifier noVault(address owner_){
    require(vaultIndex[owner_]._owner==address(0),'vaultCreate: you already have a vault');
    _;
}

modifier hasGivenAllowance(address[] calldata tokens_,uint256[] calldata _amounts){
    require(tokens_.length==_amounts.length,'TokenDeposit: number of tokens does not match number of amounts');
    for(uint256 i; i<tokens_.length;i++){
        IERC20 _t=IERC20(tokens_[i]);
        require(_t.allowance)
    }
}


//function createVault(uint256 _startingWeiBal, address[] calldata inheritors, uint8 vaultType,address[] calldata tokenDeps, uint256[] _amounts) public noVault(msg.sender)



}
