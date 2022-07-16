pragma solidity 0.8.4;

interface IVaultFacet {
    struct TokenAllocs {
        address token;
        uint256 amount;
    }
    struct AllInheritorTokenAllocs {
        address inheritor_;
        address token;
        uint256 amount;
    }

    struct AllInheritorEtherAllocs {
        address inheritor;
        uint256 weiAlloc;
    }

    struct TokenBal {
        address token;
        uint256 bal;
    }

    struct VaultInfo {
        address owner;
        uint256 weiBalance;
        uint256 lastPing;
        uint256 id;
        address backup;
        address[] inheritors;
    }

    event vaultCreated(
        address indexed owner,
        address indexed backup,
        uint256 indexed startingBalance,
        address[] inheritors
    );


    event EthDeposited(uint256 _amount);
   
    
}
