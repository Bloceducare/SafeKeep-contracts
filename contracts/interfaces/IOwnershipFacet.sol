pragma solidity 0.8.4;

interface IOwnershipFacet {
    function owner() external view returns (address owner_);
}
