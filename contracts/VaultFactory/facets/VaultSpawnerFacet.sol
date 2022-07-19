pragma solidity 0.8.4;

import "../../Vault/VaultDiamond.sol";
import "../libraries/LibAppStorage.sol";
import "../../Vault/libraries/LibKeep.sol";
import "../../interfaces/IVaultDiamond.sol";

contract VaultSpawnerFacet is StorageLayout {
      event vaultCreated(
        address indexed owner,
        address indexed backup,
        uint256 indexed startingBalance,
        uint256 vaultID
    );
  error BackupAddressError();

  function createVault(
    address[] calldata _inheritors,
    uint256[] calldata _weiShare,
    uint256 _startingBal,
    address _backupAddress
  ) external payable returns (address addr) {
    if (_backupAddress == msg.sender) revert BackupAddressError();
    if (_startingBal > 0) {
      assert(_startingBal == msg.value);
    }
    assert(_inheritors.length==_weiShare.length);
    //spawn contract
    bytes memory code = type(SafeKeep).creationCode;
    bytes32 entropy = keccak256(
      abi.encode(msg.sender, block.timestamp, fs.VAULTID)
    );
    assembly {
      addr := create2(0, add(code, 0x20), mload(code), entropy)
      if iszero(extcodesize(addr)) {
        revert(0, 0)
      }
    }
    //init diamond with diamondCut facet
    //insert a constant cut facet...modular and reusable across diamonds
    IVaultDiamond(addr).init(fs.diamondCutFacet);
    //assert diamond owner
    assert(IVaultDiamond(addr).vaultOwner()==msg.sender);

    //add inheritors if any
    //this will fail because only the owner can add inheritors
    if(_inheritors.length>0){
        LibKeep._addInheritors(_inheritors,_weiShare);
    }
    emit vaultCreated(msg.sender,_backupAddress,_startingBal,fs.VAULTID);
    fs.VAULTID++;

  }
}
