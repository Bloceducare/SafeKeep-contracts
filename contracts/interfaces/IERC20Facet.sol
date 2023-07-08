pragma solidity 0.8.4;

interface IERC20Facet {
    function depositERC20Token(address _token, uint256 _amount) external;

    function depositERC20Tokens(
        address[] calldata _tokens,
        uint256[] calldata _amounts
    ) external;

    function withdrawERC20Token(
        address _token,
        uint256 _amount,
        address _to
    ) external;

    function batchWithdrawERC20Token(
        address[] calldata _tokens,
        uint256[] calldata _amounts,
        address _to
    ) external;

    function approveERC20Token(
        address _token,
        address _to,
        uint256 _amount
    ) external;
}
