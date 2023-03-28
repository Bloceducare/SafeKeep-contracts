pragma solidity 0.8.4;

interface IERC1155Facet {
    function depositERC1155Token(
        address _token,
        uint256 _tokenID,
        uint256 _amount
    ) external;

    function batchDepositERC1155Tokens(
        address _token,
        uint256[] calldata _tokenIDs,
        uint256[] calldata _amounts
    ) external;

    function withdrawERC1155Token(
        address _token,
        uint256 _tokenID,
        uint256 _amount,
        address _to
    ) external;

    function batchWithdrawERC1155Token(
        address _token,
        uint256[] calldata _tokenIDs,
        uint256[] calldata _amount,
        address _to
    ) external;

    function approveERC1155Token(
        address _token,
        address _to,
        bool _approved
    ) external;

    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) external pure returns (bytes4);

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) external pure returns (bytes4);
}
