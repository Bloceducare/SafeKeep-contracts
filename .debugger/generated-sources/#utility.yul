{
    { }
    function abi_decode_address(offset) -> value
    {
        value := calldataload(offset)
        if iszero(eq(value, and(value, sub(shl(160, 1), 1)))) { revert(0, 0) }
    }
    function abi_decode_array_address_dyn_calldata(offset, end) -> arrayPos, length
    {
        if iszero(slt(add(offset, 0x1f), end)) { revert(length, length) }
        length := calldataload(offset)
        if gt(length, 0xffffffffffffffff) { revert(arrayPos, arrayPos) }
        arrayPos := add(offset, 0x20)
        if gt(add(add(offset, shl(5, length)), 0x20), end) { revert(0, 0) }
    }
    function abi_decode_tuple_t_address(headStart, dataEnd) -> value0
    {
        if slt(sub(dataEnd, headStart), 32) { revert(value0, value0) }
        value0 := abi_decode_address(headStart)
    }
    function abi_decode_tuple_t_addresst_array$_t_address_$dyn_memory_ptr(headStart, dataEnd) -> value0, value1
    {
        if slt(sub(dataEnd, headStart), 64) { revert(value1, value1) }
        value0 := abi_decode_address(headStart)
        let _1 := 32
        let offset := calldataload(add(headStart, _1))
        let _2 := 0xffffffffffffffff
        if gt(offset, _2) { revert(value1, value1) }
        let _3 := add(headStart, offset)
        if iszero(slt(add(_3, 0x1f), dataEnd)) { revert(value1, value1) }
        let _4 := calldataload(_3)
        if gt(_4, _2) { panic_error_0x41() }
        let _5 := shl(5, _4)
        let memPtr := mload(64)
        let newFreePtr := add(memPtr, and(add(_5, 63), not(31)))
        if or(gt(newFreePtr, _2), lt(newFreePtr, memPtr)) { panic_error_0x41() }
        mstore(64, newFreePtr)
        let dst := memPtr
        mstore(memPtr, _4)
        dst := add(memPtr, _1)
        let src := add(_3, _1)
        if gt(add(add(_3, _5), _1), dataEnd) { revert(value1, value1) }
        let i := value1
        for { } lt(i, _4) { i := add(i, 1) }
        {
            mstore(dst, abi_decode_address(src))
            dst := add(dst, _1)
            src := add(src, _1)
        }
        value1 := memPtr
    }
    function abi_decode_tuple_t_array$_t_address_$dyn_calldata_ptrt_uint256t_address(headStart, dataEnd) -> value0, value1, value2, value3
    {
        if slt(sub(dataEnd, headStart), 96) { revert(value2, value2) }
        let offset := calldataload(headStart)
        if gt(offset, 0xffffffffffffffff) { revert(value2, value2) }
        let value0_1, value1_1 := abi_decode_array_address_dyn_calldata(add(headStart, offset), dataEnd)
        value0 := value0_1
        value1 := value1_1
        value2 := calldataload(add(headStart, 32))
        value3 := abi_decode_address(add(headStart, 64))
    }
    function abi_decode_tuple_t_bool_fromMemory(headStart, dataEnd) -> value0
    {
        if slt(sub(dataEnd, headStart), 32) { revert(value0, value0) }
        let value := mload(headStart)
        if iszero(eq(value, iszero(iszero(value)))) { revert(value0, value0) }
        value0 := value
    }
    function abi_decode_tuple_t_uint256(headStart, dataEnd) -> value0
    {
        if slt(sub(dataEnd, headStart), 32) { revert(value0, value0) }
        value0 := calldataload(headStart)
    }
    function abi_decode_tuple_t_uint256_fromMemory(headStart, dataEnd) -> value0
    {
        if slt(sub(dataEnd, headStart), 32) { revert(value0, value0) }
        value0 := mload(headStart)
    }
    function abi_decode_tuple_t_uint256t_address(headStart, dataEnd) -> value0, value1
    {
        if slt(sub(dataEnd, headStart), 64) { revert(value0, value0) }
        value0 := calldataload(headStart)
        value1 := abi_decode_address(add(headStart, 32))
    }
    function abi_decode_tuple_t_uint256t_addresst_array$_t_address_$dyn_calldata_ptrt_array$_t_uint256_$dyn_calldata_ptr(headStart, dataEnd) -> value0, value1, value2, value3, value4, value5
    {
        if slt(sub(dataEnd, headStart), 128) { revert(value4, value4) }
        value0 := calldataload(headStart)
        value1 := abi_decode_address(add(headStart, 32))
        let offset := calldataload(add(headStart, 64))
        let _1 := 0xffffffffffffffff
        if gt(offset, _1) { revert(value4, value4) }
        let value2_1, value3_1 := abi_decode_array_address_dyn_calldata(add(headStart, offset), dataEnd)
        value2 := value2_1
        value3 := value3_1
        let offset_1 := calldataload(add(headStart, 96))
        if gt(offset_1, _1) { revert(value4, value4) }
        let value4_1, value5_1 := abi_decode_array_address_dyn_calldata(add(headStart, offset_1), dataEnd)
        value4 := value4_1
        value5 := value5_1
    }
    function abi_decode_tuple_t_uint256t_array$_t_address_$dyn_calldata_ptr(headStart, dataEnd) -> value0, value1, value2
    {
        if slt(sub(dataEnd, headStart), 64) { revert(value0, value0) }
        value0 := calldataload(headStart)
        let offset := calldataload(add(headStart, 32))
        if gt(offset, 0xffffffffffffffff) { revert(value1, value1) }
        let value1_1, value2_1 := abi_decode_array_address_dyn_calldata(add(headStart, offset), dataEnd)
        value1 := value1_1
        value2 := value2_1
    }
    function abi_decode_tuple_t_uint256t_array$_t_address_$dyn_calldata_ptrt_array$_t_uint256_$dyn_calldata_ptr(headStart, dataEnd) -> value0, value1, value2, value3, value4
    {
        if slt(sub(dataEnd, headStart), 96) { revert(value4, value4) }
        value0 := calldataload(headStart)
        let offset := calldataload(add(headStart, 32))
        let _1 := 0xffffffffffffffff
        if gt(offset, _1) { revert(value4, value4) }
        let value1_1, value2_1 := abi_decode_array_address_dyn_calldata(add(headStart, offset), dataEnd)
        value1 := value1_1
        value2 := value2_1
        let offset_1 := calldataload(add(headStart, 64))
        if gt(offset_1, _1) { revert(value4, value4) }
        let value3_1, value4_1 := abi_decode_array_address_dyn_calldata(add(headStart, offset_1), dataEnd)
        value3 := value3_1
        value4 := value4_1
    }
    function abi_decode_tuple_t_uint256t_uint256(headStart, dataEnd) -> value0, value1
    {
        if slt(sub(dataEnd, headStart), 64) { revert(value0, value0) }
        value0 := calldataload(headStart)
        value1 := calldataload(add(headStart, 32))
    }
    function abi_encode_array_address_dyn(value, pos) -> end
    {
        let length := mload(value)
        mstore(pos, length)
        let _1 := 0x20
        pos := add(pos, _1)
        let srcPtr := add(value, _1)
        let i := end
        for { } lt(i, length) { i := add(i, 1) }
        {
            mstore(pos, and(mload(srcPtr), sub(shl(160, 1), 1)))
            pos := add(pos, _1)
            srcPtr := add(srcPtr, _1)
        }
        end := pos
    }
    function abi_encode_string(value, pos) -> end
    {
        let length := mload(value)
        mstore(pos, length)
        let i := end
        for { } lt(i, length) { i := add(i, 0x20) }
        {
            let _1 := 0x20
            mstore(add(add(pos, i), _1), mload(add(add(value, i), _1)))
        }
        if gt(i, length)
        {
            mstore(add(add(pos, length), 0x20), end)
        }
        end := add(add(pos, and(add(length, 31), not(31))), 0x20)
    }
    function abi_encode_struct_allInheritorEtherAllocs(value, pos)
    {
        mstore(pos, and(mload(value), sub(shl(160, 1), 1)))
        mstore(add(pos, 0x20), mload(add(value, 0x20)))
    }
    function abi_encode_tuple_t_address__to_t_address__fromStack_reversed(headStart, value0) -> tail
    {
        tail := add(headStart, 32)
        mstore(headStart, and(value0, sub(shl(160, 1), 1)))
    }
    function abi_encode_tuple_t_address_t_address__to_t_address_t_address__fromStack_reversed(headStart, value1, value0) -> tail
    {
        tail := add(headStart, 64)
        let _1 := sub(shl(160, 1), 1)
        mstore(headStart, and(value0, _1))
        mstore(add(headStart, 32), and(value1, _1))
    }
    function abi_encode_tuple_t_address_t_address_t_uint256__to_t_address_t_address_t_uint256__fromStack_reversed(headStart, value2, value1, value0) -> tail
    {
        tail := add(headStart, 96)
        let _1 := sub(shl(160, 1), 1)
        mstore(headStart, and(value0, _1))
        mstore(add(headStart, 32), and(value1, _1))
        mstore(add(headStart, 64), value2)
    }
    function abi_encode_tuple_t_address_t_uint256__to_t_address_t_uint256__fromStack_reversed(headStart, value1, value0) -> tail
    {
        tail := add(headStart, 64)
        mstore(headStart, and(value0, sub(shl(160, 1), 1)))
        mstore(add(headStart, 32), value1)
    }
    function abi_encode_tuple_t_address_t_uint256_t_uint256_t_uint256_t_address__to_t_address_t_uint256_t_uint256_t_uint256_t_address__fromStack_reversed(headStart, value4, value3, value2, value1, value0) -> tail
    {
        tail := add(headStart, 160)
        let _1 := sub(shl(160, 1), 1)
        mstore(headStart, and(value0, _1))
        mstore(add(headStart, 32), value1)
        mstore(add(headStart, 64), value2)
        mstore(add(headStart, 96), value3)
        mstore(add(headStart, 128), and(value4, _1))
    }
    function abi_encode_tuple_t_array$_t_address_$dyn_memory_ptr__to_t_array$_t_address_$dyn_memory_ptr__fromStack_reversed(headStart, value0) -> tail
    {
        mstore(headStart, 32)
        tail := abi_encode_array_address_dyn(value0, add(headStart, 32))
    }
    function abi_encode_tuple_t_array$_t_address_$dyn_memory_ptr_t_array$_t_uint256_$dyn_memory_ptr__to_t_array$_t_address_$dyn_memory_ptr_t_array$_t_uint256_$dyn_memory_ptr__fromStack_reversed(headStart, value1, value0) -> tail
    {
        mstore(headStart, 64)
        let tail_1 := abi_encode_array_address_dyn(value0, add(headStart, 64))
        let _1 := 32
        mstore(add(headStart, _1), sub(tail_1, headStart))
        let pos := tail_1
        let length := mload(value1)
        mstore(tail_1, length)
        pos := add(tail_1, _1)
        let srcPtr := add(value1, _1)
        let i := tail
        for { } lt(i, length) { i := add(i, 1) }
        {
            mstore(pos, mload(srcPtr))
            pos := add(pos, _1)
            srcPtr := add(srcPtr, _1)
        }
        tail := pos
    }
    function abi_encode_tuple_t_array$_t_struct$_allInheritorEtherAllocs_$1154_memory_ptr_$dyn_memory_ptr__to_t_array$_t_struct$_allInheritorEtherAllocs_$1154_memory_ptr_$dyn_memory_ptr__fromStack_reversed(headStart, value0) -> tail
    {
        let _1 := 32
        let tail_1 := add(headStart, _1)
        mstore(headStart, _1)
        let pos := tail_1
        let length := mload(value0)
        mstore(tail_1, length)
        let _2 := 64
        pos := add(headStart, _2)
        let srcPtr := add(value0, _1)
        let i := tail
        for { } lt(i, length) { i := add(i, 1) }
        {
            abi_encode_struct_allInheritorEtherAllocs(mload(srcPtr), pos)
            pos := add(pos, _2)
            srcPtr := add(srcPtr, _1)
        }
        tail := pos
    }
    function abi_encode_tuple_t_array$_t_struct$_allInheritorTokenAllocs_$1149_memory_ptr_$dyn_memory_ptr__to_t_array$_t_struct$_allInheritorTokenAllocs_$1149_memory_ptr_$dyn_memory_ptr__fromStack_reversed(headStart, value0) -> tail
    {
        let _1 := 32
        let tail_1 := add(headStart, _1)
        mstore(headStart, _1)
        let pos := tail_1
        let length := mload(value0)
        mstore(tail_1, length)
        let _2 := 64
        pos := add(headStart, _2)
        let srcPtr := add(value0, _1)
        let i := tail
        for { } lt(i, length) { i := add(i, 1) }
        {
            let _3 := mload(srcPtr)
            let _4 := sub(shl(160, 1), 1)
            mstore(pos, and(mload(_3), _4))
            mstore(add(pos, _1), and(mload(add(_3, _1)), _4))
            mstore(add(pos, _2), mload(add(_3, _2)))
            pos := add(pos, 0x60)
            srcPtr := add(srcPtr, _1)
        }
        tail := pos
    }
    function abi_encode_tuple_t_array$_t_struct$_tokenAllocs_$1142_memory_ptr_$dyn_memory_ptr__to_t_array$_t_struct$_tokenAllocs_$1142_memory_ptr_$dyn_memory_ptr__fromStack_reversed(headStart, value0) -> tail
    {
        let _1 := 32
        let tail_1 := add(headStart, _1)
        mstore(headStart, _1)
        let pos := tail_1
        let length := mload(value0)
        mstore(tail_1, length)
        let _2 := 64
        pos := add(headStart, _2)
        let srcPtr := add(value0, _1)
        let i := tail
        for { } lt(i, length) { i := add(i, 1) }
        {
            abi_encode_struct_allInheritorEtherAllocs(mload(srcPtr), pos)
            pos := add(pos, _2)
            srcPtr := add(srcPtr, _1)
        }
        tail := pos
    }
    function abi_encode_tuple_t_array$_t_struct$_tokenBal_$1159_memory_ptr_$dyn_memory_ptr__to_t_array$_t_struct$_tokenBal_$1159_memory_ptr_$dyn_memory_ptr__fromStack_reversed(headStart, value0) -> tail
    {
        let _1 := 32
        let tail_1 := add(headStart, _1)
        mstore(headStart, _1)
        let pos := tail_1
        let length := mload(value0)
        mstore(tail_1, length)
        let _2 := 64
        pos := add(headStart, _2)
        let srcPtr := add(value0, _1)
        let i := tail
        for { } lt(i, length) { i := add(i, 1) }
        {
            abi_encode_struct_allInheritorEtherAllocs(mload(srcPtr), pos)
            pos := add(pos, _2)
            srcPtr := add(srcPtr, _1)
        }
        tail := pos
    }
    function abi_encode_tuple_t_bool__to_t_bool__fromStack_reversed(headStart, value0) -> tail
    {
        tail := add(headStart, 32)
        mstore(headStart, iszero(iszero(value0)))
    }
    function abi_encode_tuple_t_string_memory_ptr_t_uint256_t_string_memory_ptr__to_t_string_memory_ptr_t_uint256_t_string_memory_ptr__fromStack_reversed(headStart, value2, value1, value0) -> tail
    {
        mstore(headStart, 96)
        let tail_1 := abi_encode_string(value0, add(headStart, 96))
        mstore(add(headStart, 32), value1)
        mstore(add(headStart, 64), sub(tail_1, headStart))
        tail := abi_encode_string(value2, tail_1)
    }
    function abi_encode_tuple_t_stringliteral_05f0ccf0b9545f51f29fa4d010866758f38ac9637e5c6848948bb0afd5fbd9a9__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 46)
        mstore(add(headStart, 64), "activateInheritors:you are not t")
        mstore(add(headStart, 96), "he vault owner")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_stringliteral_19f962654c607938ebe7d757ae5b3c9c320ae346ef9cb1e9775c986284e16be6__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 76)
        mstore(add(headStart, 64), "withdrawEth: Not enough eth, Una")
        mstore(add(headStart, 96), "llocate from some inheritors or ")
        mstore(add(headStart, 128), "deposit more")
        tail := add(headStart, 160)
    }
    function abi_encode_tuple_t_stringliteral_1f036d20b1c70ce55c594701b107d445971fac3be00045750caee361d52a5bc6__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 50)
        mstore(add(headStart, 64), "ClaimEth: you do not have alloca")
        mstore(add(headStart, 96), "ted eth this vault")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_stringliteral_217adec7d7bb55d95a8c6aa0aec55c8e521616e5255f55e2e577d7c3b247b8ee__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 80)
        mstore(add(headStart, 64), "TokenDeposit: you have not appro")
        mstore(add(headStart, 96), "ved safekeep to spend one or mor")
        mstore(add(headStart, 128), "e of your tokens")
        tail := add(headStart, 160)
    }
    function abi_encode_tuple_t_stringliteral_245f15ff17f551913a7a18385165551503906a406f905ac1c2437281a7cd0cfe__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 38)
        mstore(add(headStart, 64), "Ownable: new owner is the zero a")
        mstore(add(headStart, 96), "ddress")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_stringliteral_3088f21b13f3b7979e9cba0fa4cf5b8ab25a55779a898e259c6bcadc62bce3ee__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 31)
        mstore(add(headStart, 64), "Check: you are not an inheritor")
        tail := add(headStart, 96)
    }
    function abi_encode_tuple_t_stringliteral_33c31ea75610fef2859277e3c0af2dc0afd1cf62cc7aa3f8235d8fb483d0759b__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 41)
        mstore(add(headStart, 64), "AddInheritors:you are not the va")
        mstore(add(headStart, 96), "ult owner")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_stringliteral_3b0cd5c70ae29f31d4c055acd60d0a012dee53f4a88eb59957de790a7abe0b46__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 39)
        mstore(add(headStart, 64), "vaultOwner: you are not the vaul")
        mstore(add(headStart, 96), "t owner")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_stringliteral_3ead98a8df543f7b4bc6d240acf3b30297b693cce4c05616959271024cf6004b__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 24)
        mstore(add(headStart, 64), "you already have a vault")
        tail := add(headStart, 96)
    }
    function abi_encode_tuple_t_stringliteral_4427a6dddb0eac9629366e041800a0c0af047489147631749f2bbd1fbcdcc590__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 47)
        mstore(add(headStart, 64), "AddInheritors: Length of argumen")
        mstore(add(headStart, 96), "ts do not match")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_stringliteral_495f0948f9255fffec837fe81e5fdff0bf12dc28e486600b0b5667b2e429a121__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 47)
        mstore(add(headStart, 64), "AllocateEther: Length of argumen")
        mstore(add(headStart, 96), "ts do not match")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_stringliteral_4c307a46fb8c33347ecfecbe484ce8d3a12f2dd2802e27f38e064fdffb1111ed__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 62)
        mstore(add(headStart, 64), "AllocateEther: one of the addres")
        mstore(add(headStart, 96), "ses is not an active inheritor")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_stringliteral_53667edee8bc61e285bdf14305ca0819e8d4bcf64c8ba6fd72437c4ce9ddc6d2__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 62)
        mstore(add(headStart, 64), "ClaimTokens: you do not have any")
        mstore(add(headStart, 96), " allocated ether in this vault")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_stringliteral_60af7f35e2dde5b9c1ef39f846a6680b233d99d67febbf34cad35c28cb8fd251__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 41)
        mstore(add(headStart, 64), "AllocateEther:you are not the va")
        mstore(add(headStart, 96), "ult owner")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_stringliteral_6126de8aff32cc49604ed5c7942342ab9acba7f27f70a2f6aed090f19378ae43__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 54)
        mstore(add(headStart, 64), "DepositEther:Amount sent does no")
        mstore(add(headStart, 96), "t equal amount entered")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_stringliteral_6127259cea195baf8b74f8f74a57909820dccba36eb851fa89bf72b06f46b19b__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 45)
        mstore(add(headStart, 64), "Check: you are not an inheritor ")
        mstore(add(headStart, 96), "in this vault")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_stringliteral_62c7752096258cab919865b91337e3ac89dcc498fa00899aacd4bdf9a0b74be5__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 42)
        mstore(add(headStart, 64), "AllocateTokens:you are not the v")
        mstore(add(headStart, 96), "ault owner")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_stringliteral_6de657fa3c36df094bc086e64787c00825a74d001f16b7e62edaa3f2f3aa2a77__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 77)
        mstore(add(headStart, 64), "activateInheritors:one or more i")
        mstore(add(headStart, 96), "nheritor is already removed or d")
        mstore(add(headStart, 128), "oes not exist")
        tail := add(headStart, 160)
    }
    function abi_encode_tuple_t_stringliteral_7146c4c22d74ccdfd2d1e886eb26796dcfae310ab22b64f0d06a5aa929d16da4__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 53)
        mstore(add(headStart, 64), "CreateVault: Sent ether does not")
        mstore(add(headStart, 96), " match inputted ether")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_stringliteral_783106fb4c80608983becfd574df20bf9dca999718f9c237a3cc28054d7e0037__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 63)
        mstore(add(headStart, 64), "AllocateTokens: one of the addre")
        mstore(add(headStart, 96), "sses is not an active inheritor")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_stringliteral_788e4e73450adf9ec2b36aeadb4137076ead7679f33cc20ebe07c602e94e19c7__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 49)
        mstore(add(headStart, 64), "vaultBackup: you are not the vau")
        mstore(add(headStart, 96), "lt backup address")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_stringliteral_7c2de9b39968d59eabdd6fc66a30e9e6a1f891107746323e2fd35f5d548a1177__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 90)
        mstore(add(headStart, 64), "AddInheritors:you do not have th")
        mstore(add(headStart, 96), "at much ether to allocate,unallo")
        mstore(add(headStart, 128), "cate or deposit more ether")
        tail := add(headStart, 160)
    }
    function abi_encode_tuple_t_stringliteral_80290d785788f6a19be357cc515600ad515fcc5424a264f9541c244204d500af__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 48)
        mstore(add(headStart, 64), "AllocateTokens: Length of argume")
        mstore(add(headStart, 96), "nts do not match")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_stringliteral_901c098f78f7ec64884fc6c60bd6785a363029f43850726f1ef851de162d2ecc__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 15)
        mstore(add(headStart, 64), "Has not expired")
        tail := add(headStart, 96)
    }
    function abi_encode_tuple_t_stringliteral_9924ebdf1add33d25d4ef888e16131f0a5687b0580a36c21b5c301a6c462effe__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 32)
        mstore(add(headStart, 64), "Ownable: caller is not the owner")
        tail := add(headStart, 96)
    }
    function abi_encode_tuple_t_stringliteral_9fa9a355e3cedb397a1f7b8942b10993ace94aa3f8063d32da5c25d1e5d5964b__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 63)
        mstore(add(headStart, 64), "ClaimTokens: you do not have any")
        mstore(add(headStart, 96), " allocated tokens in this vault")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_stringliteral_a5b914616624b47adf3a8b195f0fb785e154861c2730bd6ffbf6566943c5d601__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 91)
        mstore(add(headStart, 64), "AllocateEther: you do not have t")
        mstore(add(headStart, 96), "hat much Ether to allocate,unall")
        mstore(add(headStart, 128), "ocate or deposit more ether")
        tail := add(headStart, 160)
    }
    function abi_encode_tuple_t_stringliteral_a745103143bbf96dda3129b4b1937284feaae5b4eac6a6231798cd6ff7cddcd6__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 74)
        mstore(add(headStart, 64), "AddInheritors: one or more of th")
        mstore(add(headStart, 96), "e addresses is already an active")
        mstore(add(headStart, 128), " inheritor")
        tail := add(headStart, 160)
    }
    function abi_encode_tuple_t_stringliteral_aaafd03ee182d0dd36244ad0b9f65e8f1c69c80a0476d012b0d3e5f8546a0239__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 11)
        mstore(add(headStart, 64), "Has expired")
        tail := add(headStart, 96)
    }
    function abi_encode_tuple_t_stringliteral_e4c8576f3a610929be5362c814a126b4098da4b9fa3a6a6cb8b34f3a0c4884c2__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 30)
        mstore(add(headStart, 64), "Vault has not been created yet")
        tail := add(headStart, 96)
    }
    function abi_encode_tuple_t_stringliteral_eb30def284718313d32c5aff3e5d5b0f70e1fb22041df17efcbe3c0a0799b2f4__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 80)
        mstore(add(headStart, 64), "withdrawToken:Not enough tokens,")
        mstore(add(headStart, 96), " unallocate from some inheritors")
        mstore(add(headStart, 128), " or deposit more")
        tail := add(headStart, 160)
    }
    function abi_encode_tuple_t_stringliteral_ebf73bba305590e4764d5cb53b69bffd6d4d092d1a67551cb346f8cfcdab8619__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 31)
        mstore(add(headStart, 64), "ReentrancyGuard: reentrant call")
        tail := add(headStart, 96)
    }
    function abi_encode_tuple_t_stringliteral_f7ab10f2b4746d88a8f4cc9136082bb6cdb75728c7782e072668667d8db4aadb__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 94)
        mstore(add(headStart, 64), "AllocateTokens: you do not have ")
        mstore(add(headStart, 96), "that much tokens to allocate,una")
        mstore(add(headStart, 128), "llocate or deposit more tokens")
        tail := add(headStart, 160)
    }
    function abi_encode_tuple_t_stringliteral_fbe18e1db9763001cba24bb42d8e0d84d2b96972b2e01591a92e51c6f76301b6__to_t_string_memory_ptr__fromStack_reversed(headStart) -> tail
    {
        mstore(headStart, 32)
        mstore(add(headStart, 32), 63)
        mstore(add(headStart, 64), "TokenDeposit: number of tokens d")
        mstore(add(headStart, 96), "oes not match number of amounts")
        tail := add(headStart, 128)
    }
    function abi_encode_tuple_t_uint256__to_t_uint256__fromStack_reversed(headStart, value0) -> tail
    {
        tail := add(headStart, 32)
        mstore(headStart, value0)
    }
    function checked_add_t_uint256(x, y) -> sum
    {
        if gt(x, not(y)) { panic_error_0x11() }
        sum := add(x, y)
    }
    function checked_sub_t_uint256(x, y) -> diff
    {
        if lt(x, y) { panic_error_0x11() }
        diff := sub(x, y)
    }
    function increment_t_uint256(value) -> ret
    {
        if eq(value, not(0)) { panic_error_0x11() }
        ret := add(value, 1)
    }
    function panic_error_0x11()
    {
        mstore(0, shl(224, 0x4e487b71))
        mstore(4, 0x11)
        revert(0, 0x24)
    }
    function panic_error_0x41()
    {
        mstore(0, shl(224, 0x4e487b71))
        mstore(4, 0x41)
        revert(0, 0x24)
    }
}