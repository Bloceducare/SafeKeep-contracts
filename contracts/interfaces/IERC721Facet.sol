pragma solidity 0.8.4;

interface IERC721Facet {
    function depositERC721Token(address _token, uint256 _tokenID) external;

    function depositERC721Tokens(
        address _token,
        uint256[] calldata _tokenIDs
    ) external;

    function safeDepositERC721Token(address _token, uint256 _tokenID) external;

    function safeDepositERC721TokenAndCall(
        address _token,
        uint256 _tokenID,
        bytes calldata data
    ) external;

    function withdrawERC721Token(
        address _token,
        uint256 _tokenID,
        address _to
    ) external;

    function approveSingleERC721Token(
        address _token,
        address _to,
        uint256 _tokenID
    ) external;

    function approveAllERC721Token(
        address _token,
        address _to,
        bool _approved
    ) external;

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) external pure returns (bytes4);
}
