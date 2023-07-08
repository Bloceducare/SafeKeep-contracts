pragma solidity 0.8.4;

import {LibDMSGuards} from "./LibDMSGuards.sol";
import {LibDiamond} from "./LibDiamond.sol";
import "./LibArrayHelpers.sol";
import "../../interfaces/IERC20.sol";

import "../../interfaces/IERC721.sol";

import "../../interfaces/IERC1155.sol";

import {DMSData, FacetAndSelectorData} from "../libraries/LibLayoutSilo.sol";
import "../libraries/LibStorageBinder.sol";
import {LibErrors} from "../libraries/LibErrors.sol";

import {LibCore} from "../libraries/LibCore.sol";

library LibDMS {
    event InheritorsAdded(address[] newInheritors, uint256 vaultID);
    event InheritorsRemoved(address[] inheritors, uint256 vaultID);
    event EthAllocated(address[] inheritors, uint256[] amounts, uint256 vaultID);
    event ERC721ErrorHandled(uint256 _failedTokenId, string reason);
    event ERC20TokensAllocated(address indexed token, address[] inheritors, uint256[] amounts, uint256 vaultID);
    event ERC721TokensAllocated(address indexed token, address inheritor, uint256 tokenID, uint256 vaultID);
    event ERC1155TokensAllocated(address indexed token, address inheritor, uint256 tokenID, uint256 amount, uint256 vaultID);

    event EthClaimed(address indexed inheritor, uint256 _amount, uint256 vaultID);

    event ERC20TokensClaimed(address indexed inheritor, address indexed token, uint256 amount, uint256 vaultID);

    event ERC721TokenClaimed(address indexed inheritor, address indexed token, uint256 tokenID, uint256 vaultID);
    event ERC1155TokensClaimed(address indexed inheritor, address indexed token, uint256 tokenID, uint256 amount, uint256 vaultID);

    error ActiveInheritor();
    error NotEnoughEtherToAllocate(uint256);
    error NotInheritor();
    error EtherAllocationOverflow(uint256 overflow);
    error TokenAllocationOverflow(address token, uint256 overflow);
    error InactiveInheritor();
    error NoAllocatedTokens();

    function getCurrentAllocatedEth() internal view returns (uint256) {
        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        uint256 totalEthAllocated;
        for (uint256 x; x < dmsData.inheritors.length; x++) {
            totalEthAllocated += dmsData.inheritorWeishares[dmsData.inheritors[x]];
        }
        return totalEthAllocated;
    }

    function getCurrentAllocatedTokens(address _token) internal view returns (uint256) {
        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        uint256 totalTokensAllocated;
        for (uint256 x; x < dmsData.inheritors.length; x++) {
            totalTokensAllocated += dmsData.inheritorTokenShares[dmsData.inheritors[x]][_token];
        }
        return totalTokensAllocated;
    }

    function getCurrentAllocated1155tokens(address _token, uint256 _tokenID) internal view returns (uint256 alloc_) {
        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        for (uint256 x; x < dmsData.inheritors.length; x++) {
            alloc_ += dmsData.inheritorERC1155TokenAllocations[dmsData.inheritors[x]][_token][_tokenID];
        }
    }

    function _isERC721Allocated(address _token, uint256 _tokenId) internal view returns (bool allocated_) {
        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        allocated_ = dmsData.allocatedERC721Tokens[_token][_tokenId];
    }

    function _resetClaimed(address _inheritor) internal {
        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        dmsData.inheritorWeishares[_inheritor] = 0;
        //resetting all token allocations if he has any
        if (dmsData.inheritorAllocatedERC20Tokens[_inheritor].length > 0) {
            //remove all token addresses
            delete dmsData.inheritorAllocatedERC20Tokens[_inheritor];
        }

        if (dmsData.inheritorAllocatedERC721TokenAddresses[_inheritor].length > 0) {
            delete dmsData.inheritorAllocatedERC721TokenAddresses[_inheritor];
        }

        if (dmsData.inheritorAllocatedERC1155TokenAddresses[_inheritor].length > 0) {
            delete dmsData.inheritorAllocatedERC1155TokenAddresses[_inheritor];
        }
    }

    //only used for multiple address elemented arrays
    function reset(address _inheritor) internal {
        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        dmsData.inheritorWeishares[_inheritor] = 0;
        //resetting all token allocations if he has any
        if (dmsData.inheritorAllocatedERC20Tokens[_inheritor].length > 0) {
            for (uint256 x; x < dmsData.inheritorAllocatedERC20Tokens[_inheritor].length; x++) {
                dmsData.inheritorTokenShares[_inheritor][dmsData.inheritorAllocatedERC20Tokens[_inheritor][x]] = 0;
                dmsData.inheritorActiveTokens[_inheritor][dmsData.inheritorAllocatedERC20Tokens[_inheritor][x]] = false;
            }
            //remove all token addresses
            delete dmsData.inheritorAllocatedERC20Tokens[_inheritor];
        }

        if (dmsData.inheritorAllocatedERC721TokenAddresses[_inheritor].length > 0) {
            for (uint256 x; x < dmsData.inheritorAllocatedERC721TokenAddresses[_inheritor].length; x++) {
                address tokenAddress = dmsData.inheritorAllocatedERC721TokenAddresses[_inheritor][x];
                uint256 tokenAllocated = dmsData.inheritorERC721Tokens[_inheritor][tokenAddress];
                if (tokenAllocated == 0) {
                    dmsData.whitelist[tokenAddress][_inheritor] = false;
                }
                dmsData.inheritorERC721Tokens[_inheritor][tokenAddress] = 0;
                dmsData.allocatedERC721Tokens[tokenAddress][tokenAllocated] = false;
                //also reset reverse allocation mapping
                dmsData.ERC721ToInheritor[tokenAddress][tokenAllocated] = address(0);
                delete dmsData.inheritorAllocatedTokenIds[_inheritor][tokenAddress];
            }
            //remove all token addresses
            delete dmsData.inheritorAllocatedERC721TokenAddresses[_inheritor];
        }

        if (dmsData.inheritorAllocatedERC1155TokenAddresses[_inheritor].length > 0) {
            for (uint256 x; x < dmsData.inheritorAllocatedERC1155TokenAddresses[_inheritor].length; x++) {
                dmsData.inheritorERC1155TokenAllocations[_inheritor][dmsData.inheritorAllocatedERC1155TokenAddresses[_inheritor][x]][
                    dmsData.inheritorAllocatedTokenIds[_inheritor][dmsData.inheritorAllocatedERC1155TokenAddresses[_inheritor][x]][x]
                ] = 0;
            }

            delete dmsData.inheritorAllocatedERC1155TokenAddresses[_inheritor];
        }
    }

    //INHERITOR MUTATING OPERATIONS

    function _addInheritors(address[] calldata _newInheritors, uint256[] calldata _weiShare) internal {
        if (_newInheritors.length == 0 || _weiShare.length == 0) {
            revert LibErrors.EmptyArray();
        }
        if (_newInheritors.length != _weiShare.length) {
            revert LibErrors.LengthMismatch();
        }
        LibDMSGuards._notExpired();
        uint256 total;
        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        for (uint256 k; k < _newInheritors.length; k++) {
            total += _weiShare[k];

            if (dmsData.activeInheritors[_newInheritors[k]]) {
                revert ActiveInheritor();
            }
            //append the inheritors for a vault
            dmsData.inheritors.push(_newInheritors[k]);
            dmsData.activeInheritors[_newInheritors[k]] = true;
            //   if (total + allocated > address(this).balance)
            //     revert NotEnoughEtherToAllocate(address(this).balance);
            //   dmsData.inheritorWeishares[_newInheritors[k]] = _weiShare[k];
        }
        _allocateEther(_newInheritors, _weiShare);

        LibCore._ping();
        emit InheritorsAdded(_newInheritors, LibDiamond.vaultID());
        emit EthAllocated(_newInheritors, _weiShare, LibDiamond.vaultID());
    }

    function _removeInheritors(address[] calldata _inheritors) internal {
        if (_inheritors.length == 0) {
            revert LibErrors.EmptyArray();
        }
        LibDMSGuards._notExpired();

        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        for (uint256 k; k < _inheritors.length; k++) {
            if (!dmsData.activeInheritors[_inheritors[k]]) {
                revert NotInheritor();
            }
            dmsData.activeInheritors[_inheritors[k]] = false;
            //pop out the address from the array
            LibArrayHelpers.removeAddress(dmsData.inheritors, _inheritors[k]);
            reset(_inheritors[k]);
        }
        LibCore._ping();
        emit InheritorsRemoved(_inheritors, LibDiamond.vaultID());
    }

    //ALLOCATION MUTATING OPERATIONS

    function _allocateEther(address[] calldata _inheritors, uint256[] calldata _ethShares) internal {
        if (_inheritors.length == 0 || _ethShares.length == 0) {
            revert LibErrors.EmptyArray();
        }
        if (_inheritors.length != _ethShares.length) {
            revert LibErrors.LengthMismatch();
        }

        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        for (uint256 k; k < _inheritors.length; k++) {
            if (!LibDMSGuards._activeInheritor(_inheritors[k])) {
                revert InactiveInheritor();
            }
            // update storage
            dmsData.inheritorWeishares[_inheritors[k]] = _ethShares[k];
            //make sure limit isn't exceeded
            if (getCurrentAllocatedEth() > address(this).balance) {
                revert EtherAllocationOverflow(getCurrentAllocatedEth() - address(this).balance);
            }
        }
        LibCore._ping();
        emit EthAllocated(_inheritors, _ethShares, LibDiamond.vaultID());
    }

    function _allocateERC20Tokens(
        address token,
        address[] calldata _inheritors,
        uint256[] calldata _shares
    ) internal {
        if (_inheritors.length == 0 || _shares.length == 0) {
            revert LibErrors.EmptyArray();
        }
        if (_inheritors.length != _shares.length) {
            revert LibErrors.LengthMismatch();
        }
        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        for (uint256 k; k < _inheritors.length; k++) {
            if (!LibDMSGuards._anInheritor(_inheritors[k])) {
                revert NotInheritor();
            }
            if (!LibDMSGuards._activeInheritor(_inheritors[k])) {
                revert InactiveInheritor();
            }
            dmsData.inheritorTokenShares[_inheritors[k]][token] = _shares[k];
            if (!dmsData.inheritorActiveTokens[_inheritors[k]][token] && _shares[k] > 0) {
                dmsData.inheritorAllocatedERC20Tokens[_inheritors[k]].push(token);
                dmsData.inheritorActiveTokens[_inheritors[k]][token] = true;
            }
            //if allocation is being reduced to zero
            if (_shares[k] == 0) {
                LibArrayHelpers.removeAddress(dmsData.inheritorAllocatedERC20Tokens[_inheritors[k]], token);
                //double-checking
                dmsData.inheritorActiveTokens[_inheritors[k]][token] = false;
            }
            //finally check that limit isn't exceeded
            //get vault token balance
            uint256 currentBalance = IERC20(token).balanceOf(address(this));
            if (getCurrentAllocatedTokens(token) > currentBalance) {
                revert TokenAllocationOverflow(token, getCurrentAllocatedTokens(token) - currentBalance);
            }
        }
        LibCore._ping();
        emit ERC20TokensAllocated(token, _inheritors, _shares, LibDiamond.vaultID());
    }

    function _allocateERC721Tokens(
        address _token,
        address[] calldata _inheritors,
        uint256[] calldata _tokenIDs
    ) internal {
        if (_inheritors.length == 0 || _tokenIDs.length == 0) {
            revert LibErrors.EmptyArray();
        }
        if (_inheritors.length != _tokenIDs.length) {
            revert LibErrors.LengthMismatch();
        }
        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        for (uint256 k; k < _inheritors.length; k++) {
            if (!LibDMSGuards._anInheritorOrZero(_inheritors[k])) {
                revert NotInheritor();
            }
            if (!LibDMSGuards._activeInheritor(_inheritors[k])) {
                revert InactiveInheritor();
            }
            //short-circuit
            if (dmsData.ERC721ToInheritor[_token][_tokenIDs[k]] == _inheritors[k]) {
                continue;
            }
            //confirm ownership
            try IERC721(_token).ownerOf(_tokenIDs[k]) returns (address owner) {
                if (owner == address(this)) {
                    if (dmsData.allocatedERC721Tokens[_token][_tokenIDs[k]]) {
                        address current = dmsData.ERC721ToInheritor[_token][_tokenIDs[k]];
                        //if it is being allocated to someone else
                        if (current != _inheritors[k] && current != address(0) && _inheritors[k] != address(0)) {
                            //Might add an Unallocation event
                            dmsData.whitelist[_token][current] = false;
                            LibArrayHelpers.removeUint(dmsData.inheritorAllocatedTokenIds[current][_token], _tokenIDs[k]);
                            //if no tokens remain for that address
                            if (dmsData.inheritorAllocatedTokenIds[current][_token].length == 0) {
                                //remove the address
                                LibArrayHelpers.removeAddress(dmsData.inheritorAllocatedERC721TokenAddresses[current], _token);
                            }
                        }
                        //if it is being unallocated
                        if (_inheritors[k] == address(0)) {
                            dmsData.allocatedERC721Tokens[_token][_tokenIDs[k]] = false;
                            LibArrayHelpers.removeUint(dmsData.inheritorAllocatedTokenIds[current][_token], _tokenIDs[k]);

                            if (dmsData.inheritorAllocatedTokenIds[_inheritors[k]][_token].length == 0) {
                                LibArrayHelpers.removeAddress(dmsData.inheritorAllocatedERC721TokenAddresses[current], _token);
                            }
                        }
                    } else {
                        dmsData.allocatedERC721Tokens[_token][_tokenIDs[k]] = true;
                    }
                    dmsData.ERC721ToInheritor[_token][_tokenIDs[k]] = _inheritors[k];
                    if (dmsData.inheritorAllocatedTokenIds[_inheritors[k]][_token].length == 0) {
                        dmsData.inheritorAllocatedERC721TokenAddresses[_inheritors[k]].push(_token);
                    }

                    dmsData.inheritorAllocatedTokenIds[_inheritors[k]][_token].push(_tokenIDs[k]);

                    if (_tokenIDs[k] == 0) {
                        dmsData.whitelist[_token][_inheritors[k]] = true;
                    }
                    //   dmsData.inheritorERC721Tokens[_inheritors[k]][_token] = _tokenIDs[k];
                    emit ERC721TokensAllocated(_token, _inheritors[k], _tokenIDs[k], LibDiamond.vaultID());
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
        LibCore._ping();
    }

    function _allocateERC1155Tokens(
        address _token,
        address[] calldata _inheritors,
        uint256[] calldata _tokenIDs,
        uint256[] calldata _amounts
    ) internal {
        if (_inheritors.length == 0 || _tokenIDs.length == 0) {
            revert LibErrors.EmptyArray();
        }
        if (_inheritors.length != _tokenIDs.length) {
            revert LibErrors.LengthMismatch();
        }
        if (_inheritors.length != _amounts.length) {
            revert LibErrors.LengthMismatch();
        }
        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        for (uint256 i; i < _inheritors.length; i++) {
            if (!LibDMSGuards._anInheritor(_inheritors[i])) {
                revert NotInheritor();
            }
            if (!LibDMSGuards._activeInheritor(_inheritors[i])) {
                revert InactiveInheritor();
            }
            dmsData.inheritorERC1155TokenAllocations[_inheritors[i]][_token][_tokenIDs[i]] = _amounts[i];
            //if id is just being added
            if (!LibArrayHelpers._inUintArray(dmsData.inheritorAllocatedTokenIds[_inheritors[i]][_token], _tokenIDs[i])) {
                dmsData.inheritorAllocatedTokenIds[_inheritors[i]][_token].push(_tokenIDs[i]);
            }
            //if address is just being added
            if (!LibArrayHelpers._inAddressArray(dmsData.inheritorAllocatedERC1155TokenAddresses[_inheritors[i]], _token)) {
                dmsData.inheritorAllocatedERC1155TokenAddresses[_inheritors[i]].push(_token);
            }
            //if tokens are being unallocated
            if (_amounts[i] == 0) {
                LibArrayHelpers.removeUint(dmsData.inheritorAllocatedTokenIds[_inheritors[i]][_token], _tokenIDs[i]);
            }
            //if no tokens for the token address remain
            if (dmsData.inheritorAllocatedTokenIds[_inheritors[i]][_token].length == 0) {
                LibArrayHelpers.removeAddress(dmsData.inheritorAllocatedERC1155TokenAddresses[_inheritors[i]], _token);
            }
            //confirm numbers
            uint256 allocated = getCurrentAllocated1155tokens(_token, _tokenIDs[i]);
            uint256 available = IERC1155(_token).balanceOf(address(this), _tokenIDs[i]);
            if (allocated > available) {
                revert TokenAllocationOverflow(_token, allocated - available);
            }

            emit ERC1155TokensAllocated(_token, _inheritors[i], _tokenIDs[i], _amounts[i], LibDiamond.vaultID());
        }

        LibCore._ping();
    }

    //ACCESS TRANSFER

    function _claimERC20Tokens() internal {
        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        uint256 tokens = dmsData.inheritorAllocatedERC20Tokens[msg.sender].length;
        if (tokens > 0) {
            for (uint256 i; i < tokens; i++) {
                address token = dmsData.inheritorAllocatedERC20Tokens[msg.sender][i];
                if (token == address(0)) {
                    continue;
                }
                uint256 amountToClaim = dmsData.inheritorTokenShares[msg.sender][token];
                if (amountToClaim > 0) {
                    //reset storage
                    dmsData.inheritorTokenShares[msg.sender][token] = 0;
                    IERC20(token).transfer(msg.sender, amountToClaim);
                    emit ERC20TokensClaimed(msg.sender, token, amountToClaim, LibDiamond.vaultID());
                }
            }
        }
    }

    function _claimERC721Tokens() internal {
        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        uint256 tokens = dmsData.inheritorAllocatedERC721TokenAddresses[msg.sender].length;
        if (tokens > 0) {
            for (uint256 i; i < tokens; i++) {
                address token = dmsData.inheritorAllocatedERC721TokenAddresses[msg.sender][i];
                if (token == address(0)) {
                    continue;
                }
                uint256 tokensToClaim = dmsData.inheritorAllocatedTokenIds[msg.sender][token].length;
                if (tokensToClaim > 0) {
                    for (uint256 j; j < tokensToClaim; j++) {
                        uint256 tokenID = dmsData.inheritorAllocatedTokenIds[msg.sender][token][j];
                        if (tokenID == 0) {
                            //check for whitelist
                            if (dmsData.whitelist[token][msg.sender]) {
                                dmsData.whitelist[token][msg.sender] = false;
                                IERC721(token).transferFrom(address(this), msg.sender, 0);
                                emit ERC721TokenClaimed(msg.sender, token, 0, LibDiamond.vaultID());
                            }
                        } else {
                            //test thorougly for array overflows
                            dmsData.inheritorAllocatedTokenIds[msg.sender][token][j] = 0;
                            IERC721(token).transferFrom(address(this), msg.sender, tokenID);
                            emit ERC721TokenClaimed(msg.sender, token, tokenID, LibDiamond.vaultID());
                        }
                    }
                }
            }
        }
    }

    function _claimERC1155Tokens() internal {
        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        uint256 tokens = dmsData.inheritorAllocatedERC1155TokenAddresses[msg.sender].length;
        if (tokens > 0) {
            for (uint256 i; i < tokens; i++) {
                address token = dmsData.inheritorAllocatedERC1155TokenAddresses[msg.sender][i];
                if (token == address(0)) {
                    continue;
                }
                uint256 noOfTokenIds = dmsData.inheritorAllocatedTokenIds[msg.sender][token].length;
                if (noOfTokenIds > 0) {
                    for (uint256 k; k < noOfTokenIds; k++) {
                        uint256 tokenID = dmsData.inheritorAllocatedTokenIds[msg.sender][token][k];
                        uint256 amount = dmsData.inheritorERC1155TokenAllocations[msg.sender][token][tokenID];
                        if (amount > 0) {
                            dmsData.inheritorERC1155TokenAllocations[msg.sender][token][tokenID] = 0;
                            IERC1155(token).safeTransferFrom(address(this), msg.sender, tokenID, amount, "");
                            emit ERC1155TokensClaimed(msg.sender, token, 1, amount, LibDiamond.vaultID());
                        }
                    }
                }
            }
        }
    }

    function _claimAll() internal {
        LibDMSGuards._anInheritor(msg.sender);
        LibDMSGuards._activeInheritor(msg.sender);
        LibDMSGuards._expired();
        LibDMSGuards._notClaimed(msg.sender);
        DMSData storage dmsData = LibStorageBinder._bindAndReturnDMSStorage();
        if (dmsData.inheritorWeishares[msg.sender] > 0) {
            uint256 amountToClaim = dmsData.inheritorWeishares[msg.sender];
            //reset storage
            dmsData.inheritorWeishares[msg.sender] == 0;
            (bool success, ) = msg.sender.call{value: amountToClaim}("");
            assert(success);

            emit EthClaimed(msg.sender, amountToClaim, LibDiamond.vaultID());
        }
        //claim ERC20 tokens..if any
        _claimERC20Tokens();
        //claim ERC721 Tokens if any
        _claimERC721Tokens();
        //claim ERC1155 Tokens if any
        _claimERC1155Tokens();

        //cleanup
        LibArrayHelpers.removeAddress(dmsData.inheritors, msg.sender);
        //clear storage
        //test thorougly
        _resetClaimed(msg.sender);
    }
}
