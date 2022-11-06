pragma solidity 0.8.4;

library LibKeepHelpers {
    function findAddIndex(address _item, address[] memory addressArray) internal pure returns (uint256 i) {
        for (i; i < addressArray.length; i++) {
            //using the conventional method since we cannot have duplicate addresses
            if (addressArray[i] == _item) {
                return i;
            }
        }
    }

    function findUintIndex(uint _item, uint[] memory noArray)
        internal
        pure
        returns (uint256 i)
    {
        for (i; i < noArray.length; i++) {
            if (noArray[i] == _item) {
                return i;
            }
        }
    }

    function removeUint(uint[] storage _noArray, uint to) internal {
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

    function _inUintArray(uint256[] memory _array,uint256 _targ) internal pure returns (bool exists_) {
      if(_array.length>0){
            for (uint256 i; i < _array.length; i++) {
                if (_targ == _array[i]) {
                    exists_ = true;
                }
            }
        }
    }

    function _inAddressArray(address[] memory _array,address _targ) internal pure returns (bool exists_) {
      if(_array.length>0){
            for (uint256 i; i < _array.length; i++) {
                if (_targ == _array[i]) {
                    exists_ = true;
                }
            }
        }
    }
}
