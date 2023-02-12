// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import {LibDMS} from "./LibDMS.sol";
import {MultisigData, Transaction} from "./LibMultisigData.sol";
import {FacetAndSelectorData} from "../libraries/LibLayoutSilo.sol";
import {LibStorageBinder} from "../libraries/LibStorageBinder.sol";
import {LibModuleManager} from "../libraries/LibModuleManager.sol";
import {LibErrors} from "../libraries/LibErrors.sol";
import {LibDiamond} from "../libraries/LibDiamond.sol";
import {LibGuards} from "../libraries/LibGuards.sol";

library LibMultisig {
    event QuorumUpdate(uint256 quorum);
    event NewSigner(address signer);
    event RemoveSigner(address signer);
    event Confirmation(address indexed sender, uint256 indexed transactionId);
    event Revocation(address indexed signer, uint256 indexed transactionId);
    event Submission(uint256 indexed transactionId);
    event Execution(uint256 indexed transactionId);
    event ExecutionFailure(uint256 indexed transactionId);
    event MultisigActivation(address[] signers, uint256 quorum);

    error NotSigner();
    error NotEnoughSigners();
    error SignerAlreadyExists();
    error Invalid();
    error TransactionDoesNotExist();
    error AlreadyConfirmed();

    /// @notice Activates the multisig functionality
    /// @param _signers array of addresses that are allowed to sign transactions
    /// @param _quorum the number of signers required to execute a transaction

    function _activateMultisig(
        address[] memory _signers,
        uint256 _quorum
    ) internal {
        LibGuards._onlyVaultOwner();
        if (_signers.length == 0) revert Invalid();
        if (_quorum >= _signers.length) revert NotEnoughSigners();
        MultisigData storage multisigData = LibStorageBinder
            ._bindAndReturnMultisigStorage();
        multisigData.signers = _signers;
        multisigData.quorum = _quorum;
        for (uint256 i = 0; i < _signers.length; i++) {
            address signer = _signers[i];
            multisigData.isSigner[signer] = true;
            multisigData.signers.push(signer);
        }
        emit MultisigActivation(_signers, _quorum);
    }

    /// @notice adds a new signer to the multisig
    /// @param _signer address of the new signer
    function addSigner(address _signer) internal {
        LibGuards._onlyVaultOwner();
        MultisigData storage multisigData = LibStorageBinder
            ._bindAndReturnMultisigStorage();
        if (multisigData.isSigner[_signer]) revert SignerAlreadyExists();
        multisigData.signers.push(_signer);
        multisigData.isSigner[_signer] = true;
        emit NewSigner(_signer);
    }

    /// @notice removes a signer from the multisig
    /// @param _signer address of the signer to remove
    function removeSigner(address _signer) internal {
        LibGuards._onlyVaultOwner();
        MultisigData storage multisigData = LibStorageBinder
            ._bindAndReturnMultisigStorage();
        if (!multisigData.isSigner[_signer]) revert NotSigner();
        if (multisigData.quorum > multisigData.signers.length - 1) {
            revert NotEnoughSigners();
        }
        multisigData.isSigner[_signer] = false;
        for (uint256 i = 0; i < multisigData.signers.length; i++) {
            if (multisigData.signers[i] == _signer) {
                multisigData.signers[i] = multisigData.signers[
                    multisigData.signers.length - 1
                ];
                multisigData.signers.pop();
            }
        }
    }

    /// @notice replaces a signer with a new one
    /// @param _oldSigner address of the signer to replace
    /// @param _newSigner address of the new signer

    function replaceSigner(address _oldSigner, address _newSigner) internal {
        LibGuards._onlyVaultOwner();
        MultisigData storage multisigData = LibStorageBinder
            ._bindAndReturnMultisigStorage();
        if (!multisigData.isSigner[_oldSigner]) revert NotSigner();
        if (multisigData.isSigner[_newSigner]) revert SignerAlreadyExists();
        for (uint256 i = 0; i < multisigData.signers.length; i++) {
            if (multisigData.signers[i] == _oldSigner) {
                multisigData.signers[i] = _newSigner;
            }
        }
        multisigData.isSigner[_oldSigner] = false;
        multisigData.isSigner[_newSigner] = true;
    }

    /// @notice updates the quorum of the multisig
    function updateQuorum(uint256 _quorum) internal {
        LibGuards._onlyVaultOwner();
        MultisigData storage multisigData = LibStorageBinder
            ._bindAndReturnMultisigStorage();
        multisigData.quorum = _quorum;
        emit QuorumUpdate(_quorum);
    }

    /// @notice allows vault owner to submit a transaction to be executed upon confirmation by the required number of signers
    function submitTransaction(
        address destination,
        uint256 value,
        bytes memory data
    ) internal returns (uint256) {
        LibGuards._onlyVaultOwner();
        uint256 transactionId = addTransaction(destination, value, data);
        confirmTransaction(transactionId);
        return transactionId;
    }

    /// @notice allows a signer to confirm a transaction
    function confirmTransaction(uint256 _transactionId) internal {
        MultisigData storage multisigData = LibStorageBinder
            ._bindAndReturnMultisigStorage();
        if (!multisigData.isSigner[msg.sender]) revert NotSigner();
        if (
            multisigData.transactions[_transactionId].destination == address(0)
        ) {
            revert TransactionDoesNotExist();
        }
        if (multisigData.confirmations[_transactionId][msg.sender]) {
            revert AlreadyConfirmed();
        }
        multisigData.confirmations[_transactionId][msg.sender] = true;
        emit Confirmation(msg.sender, _transactionId);
        executeTransaction(_transactionId);
    }

    /// @notice checks if a transaction has been confirmed by the required number of signers
    function isConfirmed(uint256 _transactionId) internal view returns (bool) {
        MultisigData storage multisigData = LibStorageBinder
            ._bindAndReturnMultisigStorage();
        uint256 count = 0;
        for (uint256 i = 0; i < multisigData.signers.length; i++) {
            if (
                multisigData.confirmations[_transactionId][
                    multisigData.signers[i]
                ]
            ) {
                count += 1;
            }
            if (count == multisigData.quorum) {
                return true;
            }
        }
        return count >= multisigData.quorum;
    }

    /// @notice allows a signer to revoke a transcation
    function revokeTransaction(uint256 _transactionId) internal {
        MultisigData storage multisigData = LibStorageBinder
            ._bindAndReturnMultisigStorage();
        if (!multisigData.isSigner[msg.sender]) revert NotSigner();
        if (multisigData.confirmations[_transactionId][msg.sender]) {
            revert AlreadyConfirmed();
        }
        multisigData.confirmations[_transactionId][msg.sender] = false;
        emit Revocation(msg.sender, _transactionId);
    }

    /// @notice allows caller to propose a transaction to be executed upon confirmation by the required number of signers
    function addTransaction(
        address _destination,
        uint256 _value,
        bytes memory _data
    ) private returns (uint256) {
        MultisigData storage multisigData = LibStorageBinder
            ._bindAndReturnMultisigStorage();
        uint256 transactionId = multisigData.transactionCount;
        multisigData.transactions[transactionId] = Transaction({
            destination: _destination,
            data: _data,
            value: _value,
            executed: false
        });
        multisigData.transactionCount += 1;
        emit Submission(transactionId);
        return transactionId;
    }

    /// @notice executes a transaction if it has been confirmed by the required number of signers
    function executeTransaction(uint256 _transactionId) internal {
        MultisigData storage multisigData = LibStorageBinder
            ._bindAndReturnMultisigStorage();
        if (multisigData.transactions[_transactionId].executed) {
            revert AlreadyConfirmed();
        }
        if (isConfirmed(_transactionId)) {
            Transaction storage txn = multisigData.transactions[_transactionId];

            (bool success, bytes memory returnData) = txn.destination.call(
                txn.data
            );
            if (success) {
                txn.executed = true;
                emit Execution(_transactionId);
            } else {
                txn.executed = false;
                emit ExecutionFailure(_transactionId);
            }
        }
    }

    /// @notice returns the number of confirmations for a given transaction
    function getConfirmationCount(
        uint256 _transactionId
    ) internal view returns (uint256) {
        MultisigData storage multisigData = LibStorageBinder
            ._bindAndReturnMultisigStorage();
        uint256 count = 0;
        for (uint256 i = 0; i < multisigData.signers.length; i++) {
            if (
                multisigData.confirmations[_transactionId][
                    multisigData.signers[i]
                ]
            ) {
                count += 1;
            }
        }
        return count;
    }

    /// @notice returns the total number of transactions from the given pending and executed filter
    function getTranscationCount(
        bool _pending,
        bool _executed
    ) internal view returns (uint256) {
        MultisigData storage multisigData = LibStorageBinder
            ._bindAndReturnMultisigStorage();
        uint256 count = 0;
        for (uint256 i = 0; i < multisigData.transactionCount; i++) {
            if (
                (_pending && !multisigData.transactions[i].executed) ||
                (_executed && multisigData.transactions[i].executed)
            ) {
                count += 1;
            }
        }
        return count;
    }

    /// @notice returns the number of pending transactions
    function getPendingTransactions() internal view returns (uint256) {
        MultisigData storage multisigData = LibStorageBinder
            ._bindAndReturnMultisigStorage();
        uint256[] memory transactionIds = new uint[](
            multisigData.transactionCount
        );
        uint256 count = 0;
        for (uint256 i = 0; i < multisigData.transactionCount; i++) {
            if (!multisigData.transactions[i].executed) {
                transactionIds[count] = i;
                count += 1;
            }
        }
        return count;
    }

    /// @notice returns the number of executed transactions
    function getConfirmedTransactions() internal view returns (uint256) {
        MultisigData storage multisigData = LibStorageBinder
            ._bindAndReturnMultisigStorage();
        uint256[] memory transactionIds = new uint[](
            multisigData.transactionCount
        );
        uint256 count = 0;
        for (uint256 i = 0; i < multisigData.transactionCount; i++) {
            if (isConfirmed(i)) {
                transactionIds[count] = i;
                count += 1;
            }
        }
        return count;
    }

    /// returns the number of signers on a multisig
    function getSigners() internal view returns (address[] memory) {
        MultisigData storage multisigData = LibStorageBinder
            ._bindAndReturnMultisigStorage();
        return multisigData.signers;
    }
}
