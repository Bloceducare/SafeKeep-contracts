pragma solidity 0.8.4;

import {Guards} from "./LibVaultStorage.sol";
import "./LibDiamond.sol";
import "./LibKeepHelpers.sol";
import "../../interfaces/IERC20.sol";

import "../../interfaces/IERC721.sol";

import "../../interfaces/IERC1155.sol";

bytes4 constant ERC1155_ACCEPTED = 0xf23a6e61;
bytes4 constant ERC1155_BATCH_ACCEPTED = 0xbc197c81;
bytes4 constant ERC721WithCall = 0xb88d4fde;

library LibKeep {
    event VaultPinged(uint256 lastPing, uint256 vaultID);
    event InheritorsAdded(address[] newInheritors, uint256 vaultID);
    event InheritorsRemoved(address[] inheritors, uint256 vaultID);
    event EthAllocated(address[] inheritors, uint256[] amounts, uint256 vaultID);

    event ERC20TokenWithdrawal(address token, uint256 amount, address to, uint256 vaultID);

    event ERC721TokenWIthdrawal(address token, uint256 tokenID, address to, uint256 vaultID);
    event ERC1155TokenWithdrawal(address token, uint256 tokenID, uint256 amount, address to, uint256 vaultID);
    event ERC20ErrorHandled(address);
    event ERC721ErrorHandled(uint256 _failedTokenId, string reason);

    event ERC20TokensAllocated(address indexed token, address[] inheritors, uint256[] amounts, uint256 vaultID);
    event ERC721TokensAllocated(address indexed token, address inheritor, uint256 tokenID, uint256 vaultID);
    event ERC1155TokensAllocated(
        address indexed token, address inheritor, uint256 tokenID, uint256 amount, uint256 vaultID
    );
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner, uint256 vaultID);
    event BackupTransferred(address indexed previousBackup, address indexed newBackup, uint256 vaultID);
    event EthClaimed(address indexed inheritor, uint256 _amount, uint256 vaultID);

    event ERC20TokensClaimed(address indexed inheritor, address indexed token, uint256 amount, uint256 vaultID);

    event ERC721TokenClaimed(address indexed inheritor, address indexed token, uint256 tokenID, uint256 vaultID);
    event ERC1155TokensClaimed(
        address indexed inheritor, address indexed token, uint256 tokenID, uint256 amount, uint256 vaultID
    );

    error LengthMismatch();
    error ActiveInheritor();
    error NotEnoughEtherToAllocate(uint256);
    error EmptyArray();
    error NotInheritor();
    error EtherAllocationOverflow(uint256 overflow);
    error TokenAllocationOverflow(address token, uint256 overflow);
    error InactiveInheritor();
    error InsufficientEth();
    error InsufficientTokens();
    error NoAllocatedTokens();
    error NotERC721Owner();

    //owner check is in external fn
    function _ping() internal {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        vs.lastPing = block.timestamp;
        emit VaultPinged(block.timestamp, _vaultID());
    }

    function getCurrentAllocatedEth() internal view returns (uint256) {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        uint256 totalEthAllocated;
        for (uint256 x; x < vs.inheritors.length; x++) {
            totalEthAllocated += vs.inheritorWeishares[vs.inheritors[x]];
        }
        return totalEthAllocated;
    }

    function getCurrentAllocatedTokens(address _token) internal view returns (uint256) {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        uint256 totalTokensAllocated;
        for (uint256 x; x < vs.inheritors.length; x++) {
            totalTokensAllocated += vs.inheritorTokenShares[vs.inheritors[x]][_token];
        }
        return totalTokensAllocated;
    }

    function getCurrentAllocated1155tokens(address _token, uint256 _tokenID) internal view returns (uint256 alloc_) {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        for (uint256 x; x < vs.inheritors.length; x++) {
            alloc_ += vs.inheritorERC1155TokenAllocations[vs.inheritors[x]][_token][_tokenID];
        }
    }

    function _vaultID() internal view returns (uint256 vaultID_) {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        vaultID_ = vs.vaultID;
    }

    function _resetClaimed(address _inheritor) internal {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        vs.inheritorWeishares[_inheritor] = 0;
        //resetting all token allocations if he has any
        if (vs.inheritorAllocatedERC20Tokens[_inheritor].length > 0) {
            //remove all token addresses
            delete vs.inheritorAllocatedERC20Tokens[_inheritor];
        }

        if (vs.inheritorAllocatedERC721TokenAddresses[_inheritor].length > 0) {
            delete vs.inheritorAllocatedERC721TokenAddresses[_inheritor];
        }

        if (vs.inheritorAllocatedERC1155TokenAddresses[_inheritor].length > 0) {
            delete vs.inheritorAllocatedERC1155TokenAddresses[_inheritor];
        }
    }

    //only used for multiple address elemented arrays
    function reset(address _inheritor) internal {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        vs.inheritorWeishares[_inheritor] = 0;
        //resetting all token allocations if he has any
        if (vs.inheritorAllocatedERC20Tokens[_inheritor].length > 0) {
            for (uint256 x; x < vs.inheritorAllocatedERC20Tokens[_inheritor].length; x++) {
                vs.inheritorTokenShares[_inheritor][vs.inheritorAllocatedERC20Tokens[_inheritor][x]] = 0;
                vs.inheritorActiveTokens[_inheritor][vs.inheritorAllocatedERC20Tokens[_inheritor][x]] = false;
            }
            //remove all token addresses
            delete vs.inheritorAllocatedERC20Tokens[_inheritor];
        }

        if (vs.inheritorAllocatedERC721TokenAddresses[_inheritor].length > 0) {
            for (uint256 x; x < vs.inheritorAllocatedERC721TokenAddresses[_inheritor].length; x++) {
                address tokenAddress = vs.inheritorAllocatedERC721TokenAddresses[_inheritor][x];
                uint256 tokenAllocated = vs.inheritorERC721Tokens[_inheritor][tokenAddress];
                if (tokenAllocated == 0) {
                    vs.whitelist[tokenAddress][_inheritor] = false;
                }
                vs.inheritorERC721Tokens[_inheritor][tokenAddress] = 0;
                vs.allocatedERC721Tokens[tokenAddress][tokenAllocated] = false;
                //also reset reverse allocation mapping
                vs.ERC721ToInheritor[tokenAddress][tokenAllocated] = address(0);
                delete vs.inheritorAllocatedTokenIds[_inheritor][tokenAddress];
            }
            //remove all token addresses
            delete vs.inheritorAllocatedERC721TokenAddresses[_inheritor];
        }

        if (vs.inheritorAllocatedERC1155TokenAddresses[_inheritor].length > 0) {
            for (uint256 x; x < vs.inheritorAllocatedERC1155TokenAddresses[_inheritor].length; x++) {
                vs.inheritorERC1155TokenAllocations[_inheritor][vs.inheritorAllocatedERC1155TokenAddresses[_inheritor][x]][vs
                    .inheritorAllocatedTokenIds[_inheritor][vs.inheritorAllocatedERC1155TokenAddresses[_inheritor][x]][x]]
                = 0;
            }

            delete vs.inheritorAllocatedERC1155TokenAddresses[_inheritor];
        }
    }

    //INHERITOR MUTATING OPERATIONS

    function _addInheritors(address[] calldata _newInheritors, uint256[] calldata _weiShare) internal {
        if (_newInheritors.length == 0 || _weiShare.length == 0) {
            revert EmptyArray();
        }
        if (_newInheritors.length != _weiShare.length) {
            revert LengthMismatch();
        }
        Guards._notExpired();
        uint256 total;
        VaultStorage storage vs = LibDiamond.vaultStorage();
        for (uint256 k; k < _newInheritors.length; k++) {
            total += _weiShare[k];

            if (vs.activeInheritors[_newInheritors[k]]) {
                revert ActiveInheritor();
            }
            //append the inheritors for a vault
            vs.inheritors.push(_newInheritors[k]);
            vs.activeInheritors[_newInheritors[k]] = true;
            //   if (total + allocated > address(this).balance)
            //     revert NotEnoughEtherToAllocate(address(this).balance);
            //   vs.inheritorWeishares[_newInheritors[k]] = _weiShare[k];
        }
        _allocateEther(_newInheritors, _weiShare);

        _ping();
        emit InheritorsAdded(_newInheritors, _vaultID());
        emit EthAllocated(_newInheritors, _weiShare, _vaultID());
    }

    function _removeInheritors(address[] calldata _inheritors) internal {
        if (_inheritors.length == 0) {
            revert EmptyArray();
        }
        Guards._notExpired();

        VaultStorage storage vs = LibDiamond.vaultStorage();
        for (uint256 k; k < _inheritors.length; k++) {
            if (!vs.activeInheritors[_inheritors[k]]) {
                revert NotInheritor();
            }
            vs.activeInheritors[_inheritors[k]] = false;
            //pop out the address from the array
            LibKeepHelpers.removeAddress(vs.inheritors, _inheritors[k]);
            reset(_inheritors[k]);
        }
        _ping();
        emit InheritorsRemoved(_inheritors, _vaultID());
    }

    //ALLOCATION MUTATING OPERATIONS

    function _allocateEther(address[] calldata _inheritors, uint256[] calldata _ethShares) internal {
        if (_inheritors.length == 0 || _ethShares.length == 0) {
            revert EmptyArray();
        }
        if (_inheritors.length != _ethShares.length) {
            revert LengthMismatch();
        }

        VaultStorage storage vs = LibDiamond.vaultStorage();
        for (uint256 k; k < _inheritors.length; k++) {
            if (!Guards._activeInheritor(_inheritors[k])) {
                revert InactiveInheritor();
            }
            // update storage
            vs.inheritorWeishares[_inheritors[k]] = _ethShares[k];
            //make sure limit isn't exceeded
            if (getCurrentAllocatedEth() > address(this).balance) {
                revert EtherAllocationOverflow(getCurrentAllocatedEth() - address(this).balance);
            }
        }
        _ping();
        emit EthAllocated(_inheritors, _ethShares, _vaultID());
    }

    function _allocateERC20Tokens(address token, address[] calldata _inheritors, uint256[] calldata _shares) internal {
        if (_inheritors.length == 0 || _shares.length == 0) {
            revert EmptyArray();
        }
        if (_inheritors.length != _shares.length) {
            revert LengthMismatch();
        }
        VaultStorage storage vs = LibDiamond.vaultStorage();
        for (uint256 k; k < _inheritors.length; k++) {
            if (!Guards._anInheritor(_inheritors[k])) {
                revert NotInheritor();
            }
            if (!Guards._activeInheritor(_inheritors[k])) {
                revert InactiveInheritor();
            }
            vs.inheritorTokenShares[_inheritors[k]][token] = _shares[k];
            if (!vs.inheritorActiveTokens[_inheritors[k]][token] && _shares[k] > 0) {
                vs.inheritorAllocatedERC20Tokens[_inheritors[k]].push(token);
                vs.inheritorActiveTokens[_inheritors[k]][token] = true;
            }
            //if allocation is being reduced to zero
            if (_shares[k] == 0) {
                LibKeepHelpers.removeAddress(vs.inheritorAllocatedERC20Tokens[_inheritors[k]], token);
                //double-checking
                vs.inheritorActiveTokens[_inheritors[k]][token] = false;
            }
            //finally check that limit isn't exceeded
            //get vault token balance
            uint256 currentBalance = IERC20(token).balanceOf(address(this));
            if (getCurrentAllocatedTokens(token) > currentBalance) {
                revert TokenAllocationOverflow(token, getCurrentAllocatedTokens(token) - currentBalance);
            }
        }
        _ping();
        emit ERC20TokensAllocated(token, _inheritors, _shares, _vaultID());
    }

    function _allocateERC721Tokens(address _token, address[] calldata _inheritors, uint256[] calldata _tokenIDs)
        internal
    {
        if (_inheritors.length == 0 || _tokenIDs.length == 0) {
            revert EmptyArray();
        }
        if (_inheritors.length != _tokenIDs.length) {
            revert LengthMismatch();
        }
        VaultStorage storage vs = LibDiamond.vaultStorage();
        for (uint256 k; k < _inheritors.length; k++) {
            if (!Guards._anInheritorOrZero(_inheritors[k])) {
                revert NotInheritor();
            }
            if (!Guards._activeInheritor(_inheritors[k])) {
                revert InactiveInheritor();
            }
            //short-circuit
            if (vs.ERC721ToInheritor[_token][_tokenIDs[k]] == _inheritors[k]) {
                continue;
            }
            //confirm ownership
            try IERC721(_token).ownerOf(_tokenIDs[k]) returns (address owner) {
                if (owner == address(this)) {
                    if (vs.allocatedERC721Tokens[_token][_tokenIDs[k]]) {
                        address current = vs.ERC721ToInheritor[_token][_tokenIDs[k]];
                        //if it is being allocated to someone else
                        if (current != _inheritors[k] && current != address(0) && _inheritors[k] != address(0)) {
                            //Might add an Unallocation event
                            vs.whitelist[_token][current] = false;
                            LibKeepHelpers.removeUint(vs.inheritorAllocatedTokenIds[current][_token], _tokenIDs[k]);
                            //if no tokens remain for that address
                            if (vs.inheritorAllocatedTokenIds[current][_token].length == 0) {
                                //remove the address
                                LibKeepHelpers.removeAddress(vs.inheritorAllocatedERC721TokenAddresses[current], _token);
                            }
                        }
                        //if it is being unallocated
                        if (_inheritors[k] == address(0)) {
                            vs.allocatedERC721Tokens[_token][_tokenIDs[k]] = false;
                            LibKeepHelpers.removeUint(vs.inheritorAllocatedTokenIds[current][_token], _tokenIDs[k]);

                            if (vs.inheritorAllocatedTokenIds[_inheritors[k]][_token].length == 0) {
                                LibKeepHelpers.removeAddress(vs.inheritorAllocatedERC721TokenAddresses[current], _token);
                            }
                        }
                    } else {
                        vs.allocatedERC721Tokens[_token][_tokenIDs[k]] = true;
                    }
                    vs.ERC721ToInheritor[_token][_tokenIDs[k]] = _inheritors[k];
                    if (vs.inheritorAllocatedTokenIds[_inheritors[k]][_token].length == 0) {
                        vs.inheritorAllocatedERC721TokenAddresses[_inheritors[k]].push(_token);
                    }

                    vs.inheritorAllocatedTokenIds[_inheritors[k]][_token].push(_tokenIDs[k]);

                    if (_tokenIDs[k] == 0) {
                        vs.whitelist[_token][_inheritors[k]] = true;
                    }
                    //   vs.inheritorERC721Tokens[_inheritors[k]][_token] = _tokenIDs[k];
                    emit ERC721TokensAllocated(_token, _inheritors[k], _tokenIDs[k], _vaultID());
                }
                if (owner != address(this)) {
                    emit ERC721ErrorHandled(_tokenIDs[k], "Not_Owner");
                    continue;
                }
            } catch Error(string memory r) {
                emit ERC721ErrorHandled(_tokenIDs[k], r);
                continue;
            }
        }
        _ping();
    }

    function _allocateERC1155Tokens(
        address _token,
        address[] calldata _inheritors,
        uint256[] calldata _tokenIDs,
        uint256[] calldata _amounts
    )
        internal
    {
        if (_inheritors.length == 0 || _tokenIDs.length == 0) {
            revert EmptyArray();
        }
        if (_inheritors.length != _tokenIDs.length) {
            revert LengthMismatch();
        }
        if (_inheritors.length != _amounts.length) {
            revert LengthMismatch();
        }
        VaultStorage storage vs = LibDiamond.vaultStorage();
        for (uint256 i; i < _inheritors.length; i++) {
            if (!Guards._anInheritor(_inheritors[i])) {
                revert NotInheritor();
            }
            if (!Guards._activeInheritor(_inheritors[i])) {
                revert InactiveInheritor();
            }
            vs.inheritorERC1155TokenAllocations[_inheritors[i]][_token][_tokenIDs[i]] = _amounts[i];
            //if id is just being added
            if (!LibKeepHelpers._inUintArray(vs.inheritorAllocatedTokenIds[_inheritors[i]][_token], _tokenIDs[i])) {
                vs.inheritorAllocatedTokenIds[_inheritors[i]][_token].push(_tokenIDs[i]);
            }
            //if address is just being added
            if (!LibKeepHelpers._inAddressArray(vs.inheritorAllocatedERC1155TokenAddresses[_inheritors[i]], _token)) {
                vs.inheritorAllocatedERC1155TokenAddresses[_inheritors[i]].push(_token);
            }
            //if tokens are being unallocated
            if (_amounts[i] == 0) {
                LibKeepHelpers.removeUint(vs.inheritorAllocatedTokenIds[_inheritors[i]][_token], _tokenIDs[i]);
            }
            //if no tokens for the token address remain
            if (vs.inheritorAllocatedTokenIds[_inheritors[i]][_token].length == 0) {
                LibKeepHelpers.removeAddress(vs.inheritorAllocatedERC1155TokenAddresses[_inheritors[i]], _token);
            }
            //confirm numbers
            uint256 allocated = getCurrentAllocated1155tokens(_token, _tokenIDs[i]);
            uint256 available = IERC1155(_token).balanceOf(address(this), _tokenIDs[i]);
            if (allocated > available) {
                revert TokenAllocationOverflow(_token, allocated - available);
            }

            emit ERC1155TokensAllocated(_token, _inheritors[i], _tokenIDs[i], _amounts[i], _vaultID());
        }

        _ping();
    }

    ///WITHDRAWALS

    function _withdrawEth(uint256 _amount, address _to) internal {
        //confirm free eth is sufficient
        uint256 allocated = getCurrentAllocatedEth();
        if (address(this).balance >= allocated) {
            if (address(this).balance - allocated < _amount) {
                revert InsufficientEth();
            }
            (bool success,) = _to.call{value: _amount}("");
            assert(success);
        } else {
            revert InsufficientEth();
        }
    }

    function _withdrawERC20Tokens(address[] calldata _tokenAdds, uint256[] calldata _amounts, address _to) internal {
        if (_tokenAdds.length == 0 || _amounts.length == 0) {
            revert EmptyArray();
        }
        if (_tokenAdds.length != _amounts.length) {
            revert LengthMismatch();
        }
        // VaultStorage storage vs = LibDiamond.vaultStorage();
        for (uint256 x; x < _tokenAdds.length; x++) {
            address token = _tokenAdds[x];
            uint256 amount = _amounts[x];
            uint256 availableTokens = getCurrentAllocatedTokens(token);
            uint256 currentBalance = IERC20(token).balanceOf(address(this));
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
                        emit ERC20TokenWithdrawal(token, amount, _to, _vaultID());
                    } else {
                        emit ERC20ErrorHandled(token);
                    }
                }
            } else {
                revert InsufficientTokens();
            }
        }
        _ping();
    }

    function _withdrawERC20Token(address _token, uint256 _amount, address _to) internal {
        uint256 availableTokens = getCurrentAllocatedTokens(_token);
        uint256 currentBalance = IERC20(_token).balanceOf(address(this));
        bool success;
        if (currentBalance >= availableTokens) {
            if (currentBalance - availableTokens < _amount) {
                revert InsufficientTokens();
            }
            try IERC20(_token).transfer(_to, _amount) {
                success;
            } catch {
                if (success) {
                    emit ERC20TokenWithdrawal(_token, _amount, _to, _vaultID());
                } else {
                    emit ERC20ErrorHandled(_token);
                }
            }
        } else {
            revert InsufficientTokens();
        }

        _ping();
    }

    function _withdrawERC721Token(address _token, uint256 _tokenID, address _to) internal {
        if (IERC721(_token).ownerOf(_tokenID) != address(this)) {
            revert NotERC721Owner();
        }
        VaultStorage storage vs = LibDiamond.vaultStorage();
        if (vs.allocatedERC721Tokens[_token][_tokenID]) {
            revert("UnAllocate Token First");
        }
        try IERC721(_token).safeTransferFrom(address(this), _to, _tokenID) {}
        catch {
            string memory reason;
            if (bytes(reason).length == 0) {
                emit ERC721TokenWIthdrawal(_token, _tokenID, _to, _vaultID());
            } else {
                emit ERC20ErrorHandled(_token);
            }
        }
    }

    function _withdrawERC1155Token(address _token, uint256 _tokenID, uint256 _amount, address _to) internal {
        uint256 allocated = getCurrentAllocated1155tokens(_token, _tokenID);
        uint256 balance = IERC1155(_token).balanceOf(address(this), _tokenID);
        if (balance < _amount) {
            revert InsufficientTokens();
        }

        if (balance - allocated < _amount) {
            revert("UnAllocate TokensFirst");
        }
        IERC1155(_token).safeTransferFrom(address(this), _to, _tokenID, _amount, "");
        emit ERC1155TokenWithdrawal(_token, _tokenID, _amount, _to, _vaultID());
    }

    //ACCESS TRANSFER

    function _transferOwnerShip(address _newOwner) internal {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        address prevOwner = vs.vaultOwner;
        vs.vaultOwner = _newOwner;
        emit OwnershipTransferred(prevOwner, _newOwner, _vaultID());
    }

    function _transferBackup(address _newBackupAddress) internal {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        address prevBackup = vs.backupAddress;
        vs.backupAddress = _newBackupAddress;
        emit BackupTransferred(prevBackup, _newBackupAddress, _vaultID());
    }

    ///CLAIMS

    function _claimOwnership(address _newBackup) internal {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        Guards._expired();
        address prevOwner = vs.vaultOwner;
        address prevBackup = vs.backupAddress;
        assert(prevOwner != _newBackup);
        vs.vaultOwner = msg.sender;
        vs.backupAddress = _newBackup;
        emit OwnershipTransferred(prevOwner, msg.sender, _vaultID());
        emit BackupTransferred(prevBackup, _newBackup, _vaultID());
    }

    function _claimERC20Tokens() internal {
        // Guards._anInheritor(msg.sender);
        // Guards._activeInheritor(msg.sender);
        // Guards._expired();
        VaultStorage storage vs = LibDiamond.vaultStorage();
        uint256 tokens = vs.inheritorAllocatedERC20Tokens[msg.sender].length;
        if (tokens > 0) {
            for (uint256 i; i < tokens; i++) {
                address token = vs.inheritorAllocatedERC20Tokens[msg.sender][i];
                if (token == address(0)) {
                    continue;
                }
                uint256 amountToClaim = vs.inheritorTokenShares[msg.sender][token];
                if (amountToClaim > 0) {
                    //reset storage
                    vs.inheritorTokenShares[msg.sender][token] = 0;
                    IERC20(token).transfer(msg.sender, amountToClaim);
                    emit ERC20TokensClaimed(msg.sender, token, amountToClaim, _vaultID());
                }
            }
        }
    }

    event ww(bool);

    function _claimERC721Tokens() internal {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        uint256 tokens = vs.inheritorAllocatedERC721TokenAddresses[msg.sender].length;
        if (tokens > 0) {
            for (uint256 i; i < tokens; i++) {
                address token = vs.inheritorAllocatedERC721TokenAddresses[msg.sender][i];
                if (token == address(0)) {
                    continue;
                }
                uint256 tokensToClaim = vs.inheritorAllocatedTokenIds[msg.sender][token].length;
                if (tokensToClaim > 0) {
                    for (uint256 j; j < tokensToClaim; j++) {
                        uint256 tokenID = vs.inheritorAllocatedTokenIds[msg.sender][token][j];
                        if (tokenID == 0) {
                            //check for whitelist
                            if (vs.whitelist[token][msg.sender]) {
                                vs.whitelist[token][msg.sender] = false;
                                IERC721(token).transferFrom(address(this), msg.sender, 0);
                                emit ERC721TokenClaimed(msg.sender, token, 0, _vaultID());
                            }
                        } else {
                            //test thorougly for array overflows
                            vs.inheritorAllocatedTokenIds[msg.sender][token][j] = 0;
                            IERC721(token).transferFrom(address(this), msg.sender, tokenID);
                            emit ERC721TokenClaimed(msg.sender, token, tokenID, _vaultID());
                        }
                    }
                }
            }
        }
    }

    function _claimERC1155Tokens() internal {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        uint256 tokens = vs.inheritorAllocatedERC1155TokenAddresses[msg.sender].length;
        if (tokens > 0) {
            for (uint256 i; i < tokens; i++) {
                address token = vs.inheritorAllocatedERC1155TokenAddresses[msg.sender][i];
                if (token == address(0)) {
                    continue;
                }
                uint256 noOfTokenIds = vs.inheritorAllocatedTokenIds[msg.sender][token].length;
                if (noOfTokenIds > 0) {
                    for (uint256 k; k < noOfTokenIds; k++) {
                        uint256 tokenID = vs.inheritorAllocatedTokenIds[msg.sender][token][k];
                        uint256 amount = vs.inheritorERC1155TokenAllocations[msg.sender][token][tokenID];
                        if (amount > 0) {
                            vs.inheritorERC1155TokenAllocations[msg.sender][token][tokenID] = 0;
                            IERC1155(token).safeTransferFrom(address(this), msg.sender, tokenID, amount, "");
                            emit ERC1155TokensClaimed(msg.sender, token, 1, amount, _vaultID());
                        }
                    }
                }
            }
        }
    }

    function _claimAll() internal {
        Guards._anInheritor(msg.sender);
        Guards._activeInheritor(msg.sender);
        Guards._expired();
        Guards._notClaimed(msg.sender);
        VaultStorage storage vs = LibDiamond.vaultStorage();
        if (vs.inheritorWeishares[msg.sender] > 0) {
            uint256 amountToClaim = vs.inheritorWeishares[msg.sender];
            //reset storage
            vs.inheritorWeishares[msg.sender] == 0;
            (bool success,) = msg.sender.call{value: amountToClaim}("");
            assert(success);

            emit EthClaimed(msg.sender, amountToClaim, _vaultID());
        }
        //claim ERC20 tokens..if any
        _claimERC20Tokens();
        //claim ERC721 Tokens if any
        _claimERC721Tokens();
        //claim ERC1155 Tokens if any
        _claimERC1155Tokens();

        //cleanup
        LibKeepHelpers.removeAddress(vs.inheritors, msg.sender);
        //clear storage
        //test thorougly
        _resetClaimed(msg.sender);
    }
}
