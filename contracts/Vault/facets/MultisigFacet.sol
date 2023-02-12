// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import {LibMultisig} from "../libraries/LibMultisig.sol";

contract MultisigFacet {
    function activateMultisig(
        address[] memory _signers,
        uint256 _quorum
    ) external {
        LibMultisig._activateMultisig(_signers, _quorum);
    }

    function addSigner(address _signer) external {
        LibMultisig.addSigner(_signer);
    }

    function removeSigner(address _signer) external {
        LibMultisig.removeSigner(_signer);
    }

    function replaceSigner(address _oldSigner, address _newSigner) external {
        LibMultisig.replaceSigner(_oldSigner, _newSigner);
    }

    function changeQuorum(uint256 _quorum) external {
        LibMultisig.updateQuorum(_quorum);
    }

    function submitTransaction(
        address _to,
        uint256 _value,
        bytes memory _data
    ) external returns (uint256) {
        return LibMultisig.submitTransaction(_to, _value, _data);
    }

    function confirmTransaction(uint256 _transactionId) external {
        LibMultisig.confirmTransaction(_transactionId);
    }

    function revokeTransaction(uint256 _transactionId) external {
        LibMultisig.revokeTransaction(_transactionId);
    }

    function getConfirmations(
        uint256 _transactionId
    ) external view returns (address) {
        LibMultisig.getConfirmationCount(_transactionId);
    }

    function getConfirmedTransactions() external view returns (uint256) {
        LibMultisig.getConfirmedTransactions();
    }
}
