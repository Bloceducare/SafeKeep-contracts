pragma solidity 0.8.4;

//list of shared Errors across Modules
library LibErrors {
    error LengthMismatch();
    error EmptyArray();
    error NoPermissions();
    error NoZeroAddress();
}
