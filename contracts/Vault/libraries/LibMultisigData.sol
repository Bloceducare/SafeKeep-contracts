struct MultisigData {
    address[] signers;
    uint256 quorum;
    uint256 transactionCount;
    mapping(uint256 => Transaction) transactions;
    mapping(uint256 => mapping(address => bool)) confirmations;
    mapping(address => bool) isSigner;
}

struct Transaction {
    address destination;
    uint256 value;
    bytes data;
    bool executed;
}
