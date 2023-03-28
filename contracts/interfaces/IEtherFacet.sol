pragma solidity 0.8.4;

interface IEtherFacet {
    function depositEther(uint256 _amount) external payable;

    function withdrawEther(uint256 _amount, address _to) external;
}
