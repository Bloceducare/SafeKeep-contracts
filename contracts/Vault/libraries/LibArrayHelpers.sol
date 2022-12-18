pragma solidity 0.8.4;

library LibArrayHelpers {
    /// @notice check an address index in an array
    /// @param _item address to be checked
    /// @param addressArray arrays to be checked
    function findAddIndex(
        address _item,
        address[] memory addressArray
    ) internal pure returns (uint256 i) {
        for (i; i < addressArray.length; i++) {
            //using the conventional method since we cannot have duplicate addresses
            if (addressArray[i] == _item) {
                return i;
            }
        }
    }

    /// @dev checks item index in an array
    /// @param _item to be checked
    /// @param noArray array to be looped through

    function findUintIndex(
        uint256 _item,
        uint256[] memory noArray
    ) internal pure returns (uint256 i) {
        for (i; i < noArray.length; i++) {
            if (noArray[i] == _item) {
                return i;
            }
        }
    }

    /// @notice check for sring index given an array
    function findStringIndex(
        string memory _item,
        string[] memory stringArray
    ) internal pure returns (uint256 i) {
        for (i; i < stringArray.length; i++) {
            if (__equalTo__(stringArray[i], _item)) {
                return i;
            }
        }
    }

    /// @dev checks for eqaulity of two strings
    function __equalTo__(
        string memory a,
        string memory b
    ) private pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }

    /// @dev removes string from an array
    function removeString(
        string[] storage _stringArray,
        string memory to
    ) internal {
        require(_stringArray.length > 0, "Non-elemented number array");
        uint256 index = findStringIndex(to, _stringArray);
        if (_stringArray.length == 1) {
            _stringArray.pop();
        }
        if (_stringArray.length > 1) {
            for (uint256 i = index; i < _stringArray.length - 1; i++) {
                _stringArray[i] = _stringArray[i + 1];
            }
            _stringArray.pop();
        }
    }

    /// @dev removes uint from an array
    function removeUint(uint256[] storage _noArray, uint256 to) internal {
        require(_noArray.length > 0, "Non-elemented number array");
        uint256 index = findUintIndex(to, _noArray);
        if (_noArray.length == 1) {
            _noArray.pop();
        }
        if (_noArray.length > 1) {
            for (uint256 i = index; i < _noArray.length - 1; i++) {
                _noArray[i] = _noArray[i + 1];
            }
            _noArray.pop();
        }
    }

    /// @notice removes address form _array[]
    function removeAddress(address[] storage _array, address _add) internal {
        require(_array.length > 0, "Non-elemented address array");
        uint256 index = findAddIndex(_add, _array);
        if (_array.length == 1) {
            _array.pop();
        }

        if (_array.length > 1) {
            for (uint256 i = index; i < _array.length - 1; i++) {
                _array[i] = _array[i + 1];
            }
            _array.pop();
        }
    }

    /// @notice checks fif an integer is included in the selected array
    function _inUintArray(
        uint256[] memory _array,
        uint256 _targ
    ) internal pure returns (bool exists_) {
        if (_array.length > 0) {
            for (uint256 i; i < _array.length; i++) {
                if (_targ == _array[i]) {
                    exists_ = true;
                }
            }
        }
    }

    ///  @dev checks for _targ address in _array
    function _inAddressArray(
        address[] memory _array,
        address _targ
    ) internal pure returns (bool exists_) {
        if (_array.length > 0) {
            for (uint256 i; i < _array.length; i++) {
                if (_targ == _array[i]) {
                    exists_ = true;
                }
            }
        }
    }
}
