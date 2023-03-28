/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import {
  ethers,
  EventFilter,
  Signer,
  BigNumber,
  BigNumberish,
  PopulatedTransaction,
  BaseContract,
  ContractTransaction,
  Overrides,
  CallOverrides,
} from "ethers";
import { BytesLike } from "@ethersproject/bytes";
import { Listener, Provider } from "@ethersproject/providers";
import { FunctionFragment, EventFragment, Result } from "@ethersproject/abi";
import type { TypedEventFilter, TypedEvent, TypedListener } from "./common";

interface DMSFacetInterface extends ethers.utils.Interface {
  functions: {
    "addInheritors(address[],uint256[])": FunctionFragment;
    "allEtherAllocations()": FunctionFragment;
    "allocateERC1155Tokens(address,address[],uint256[],uint256[])": FunctionFragment;
    "allocateERC20Tokens(address,address[],uint256[])": FunctionFragment;
    "allocateERC721Tokens(address,address[],uint256[])": FunctionFragment;
    "allocateEther(address[],uint256[])": FunctionFragment;
    "claimAllAllocations()": FunctionFragment;
    "claimOwnership(address)": FunctionFragment;
    "etherBalance()": FunctionFragment;
    "getAllAllocatedERC1155Tokens(address)": FunctionFragment;
    "getAllocatedERC1155Tokens(address,address)": FunctionFragment;
    "getAllocatedERC20Tokens(address)": FunctionFragment;
    "getAllocatedERC721TokenAddresses(address)": FunctionFragment;
    "getAllocatedERC721TokenIds(address,address)": FunctionFragment;
    "getAllocatedERC721Tokens(address)": FunctionFragment;
    "getAllocatedEther()": FunctionFragment;
    "getUnallocatedERC115Tokens(address,uint256)": FunctionFragment;
    "getUnallocatedEther()": FunctionFragment;
    "getUnallocatedTokens(address)": FunctionFragment;
    "inheritorERC20TokenAllocation(address,address)": FunctionFragment;
    "inheritorEtherAllocation(address)": FunctionFragment;
    "inspectVault()": FunctionFragment;
    "ping()": FunctionFragment;
    "removeInheritors(address[])": FunctionFragment;
    "transferBackup(address)": FunctionFragment;
    "transferOwnership(address)": FunctionFragment;
  };

  encodeFunctionData(
    functionFragment: "addInheritors",
    values: [string[], BigNumberish[]]
  ): string;
  encodeFunctionData(
    functionFragment: "allEtherAllocations",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "allocateERC1155Tokens",
    values: [string, string[], BigNumberish[], BigNumberish[]]
  ): string;
  encodeFunctionData(
    functionFragment: "allocateERC20Tokens",
    values: [string, string[], BigNumberish[]]
  ): string;
  encodeFunctionData(
    functionFragment: "allocateERC721Tokens",
    values: [string, string[], BigNumberish[]]
  ): string;
  encodeFunctionData(
    functionFragment: "allocateEther",
    values: [string[], BigNumberish[]]
  ): string;
  encodeFunctionData(
    functionFragment: "claimAllAllocations",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "claimOwnership",
    values: [string]
  ): string;
  encodeFunctionData(
    functionFragment: "etherBalance",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "getAllAllocatedERC1155Tokens",
    values: [string]
  ): string;
  encodeFunctionData(
    functionFragment: "getAllocatedERC1155Tokens",
    values: [string, string]
  ): string;
  encodeFunctionData(
    functionFragment: "getAllocatedERC20Tokens",
    values: [string]
  ): string;
  encodeFunctionData(
    functionFragment: "getAllocatedERC721TokenAddresses",
    values: [string]
  ): string;
  encodeFunctionData(
    functionFragment: "getAllocatedERC721TokenIds",
    values: [string, string]
  ): string;
  encodeFunctionData(
    functionFragment: "getAllocatedERC721Tokens",
    values: [string]
  ): string;
  encodeFunctionData(
    functionFragment: "getAllocatedEther",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "getUnallocatedERC115Tokens",
    values: [string, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "getUnallocatedEther",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "getUnallocatedTokens",
    values: [string]
  ): string;
  encodeFunctionData(
    functionFragment: "inheritorERC20TokenAllocation",
    values: [string, string]
  ): string;
  encodeFunctionData(
    functionFragment: "inheritorEtherAllocation",
    values: [string]
  ): string;
  encodeFunctionData(
    functionFragment: "inspectVault",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "ping", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "removeInheritors",
    values: [string[]]
  ): string;
  encodeFunctionData(
    functionFragment: "transferBackup",
    values: [string]
  ): string;
  encodeFunctionData(
    functionFragment: "transferOwnership",
    values: [string]
  ): string;

  decodeFunctionResult(
    functionFragment: "addInheritors",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "allEtherAllocations",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "allocateERC1155Tokens",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "allocateERC20Tokens",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "allocateERC721Tokens",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "allocateEther",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "claimAllAllocations",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "claimOwnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "etherBalance",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getAllAllocatedERC1155Tokens",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getAllocatedERC1155Tokens",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getAllocatedERC20Tokens",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getAllocatedERC721TokenAddresses",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getAllocatedERC721TokenIds",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getAllocatedERC721Tokens",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getAllocatedEther",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getUnallocatedERC115Tokens",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getUnallocatedEther",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getUnallocatedTokens",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "inheritorERC20TokenAllocation",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "inheritorEtherAllocation",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "inspectVault",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "ping", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "removeInheritors",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "transferBackup",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "transferOwnership",
    data: BytesLike
  ): Result;

  events: {};
}

export class DMSFacet extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  listeners<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter?: TypedEventFilter<EventArgsArray, EventArgsObject>
  ): Array<TypedListener<EventArgsArray, EventArgsObject>>;
  off<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  on<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  once<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  removeListener<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  removeAllListeners<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>
  ): this;

  listeners(eventName?: string): Array<Listener>;
  off(eventName: string, listener: Listener): this;
  on(eventName: string, listener: Listener): this;
  once(eventName: string, listener: Listener): this;
  removeListener(eventName: string, listener: Listener): this;
  removeAllListeners(eventName?: string): this;

  queryFilter<EventArgsArray extends Array<any>, EventArgsObject>(
    event: TypedEventFilter<EventArgsArray, EventArgsObject>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEvent<EventArgsArray & EventArgsObject>>>;

  interface: DMSFacetInterface;

  functions: {
    addInheritors(
      _newInheritors: string[],
      _weiShare: BigNumberish[],
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    allEtherAllocations(
      overrides?: CallOverrides
    ): Promise<
      [([string, BigNumber] & { inheritor: string; weiAlloc: BigNumber })[]] & {
        eAllocs: ([string, BigNumber] & {
          inheritor: string;
          weiAlloc: BigNumber;
        })[];
      }
    >;

    allocateERC1155Tokens(
      token: string,
      _inheritors: string[],
      _tokenIDs: BigNumberish[],
      _amounts: BigNumberish[],
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    allocateERC20Tokens(
      token: string,
      _inheritors: string[],
      _shares: BigNumberish[],
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    allocateERC721Tokens(
      token: string,
      _inheritors: string[],
      _tokenIDs: BigNumberish[],
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    allocateEther(
      _inheritors: string[],
      _ethShares: BigNumberish[],
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    claimAllAllocations(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    claimOwnership(
      _newBackupAddress: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    etherBalance(overrides?: CallOverrides): Promise<[BigNumber]>;

    getAllAllocatedERC1155Tokens(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<
      [
        ([string, BigNumber, BigNumber] & {
          token: string;
          tokenID: BigNumber;
          amount: BigNumber;
        })[]
      ] & {
        alloc_: ([string, BigNumber, BigNumber] & {
          token: string;
          tokenID: BigNumber;
          amount: BigNumber;
        })[];
      }
    >;

    getAllocatedERC1155Tokens(
      _token: string,
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<
      [
        ([BigNumber, BigNumber] & { tokenID: BigNumber; amount: BigNumber })[]
      ] & {
        alloc_: ([BigNumber, BigNumber] & {
          tokenID: BigNumber;
          amount: BigNumber;
        })[];
      }
    >;

    getAllocatedERC20Tokens(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<
      [([string, BigNumber] & { token: string; amount: BigNumber })[]] & {
        tAllocs: ([string, BigNumber] & { token: string; amount: BigNumber })[];
      }
    >;

    getAllocatedERC721TokenAddresses(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<[string[]]>;

    getAllocatedERC721TokenIds(
      _inheritor: string,
      _token: string,
      overrides?: CallOverrides
    ): Promise<[BigNumber[]]>;

    getAllocatedERC721Tokens(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<
      [([string, BigNumber[]] & { token: string; tokenIDs: BigNumber[] })[]] & {
        allocated: ([string, BigNumber[]] & {
          token: string;
          tokenIDs: BigNumber[];
        })[];
      }
    >;

    getAllocatedEther(overrides?: CallOverrides): Promise<[BigNumber]>;

    getUnallocatedERC115Tokens(
      _token: string,
      _tokenId: BigNumberish,
      overrides?: CallOverrides
    ): Promise<[BigNumber] & { remaining_: BigNumber }>;

    getUnallocatedEther(
      overrides?: CallOverrides
    ): Promise<[BigNumber] & { unallocated_: BigNumber }>;

    getUnallocatedTokens(
      _token: string,
      overrides?: CallOverrides
    ): Promise<[BigNumber] & { unallocated_: BigNumber }>;

    inheritorERC20TokenAllocation(
      _inheritor: string,
      _token: string,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    inheritorEtherAllocation(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<[BigNumber] & { _allocatedEther: BigNumber }>;

    inspectVault(
      overrides?: CallOverrides
    ): Promise<
      [
        [string, BigNumber, BigNumber, BigNumber, string, string[]] & {
          owner: string;
          weiBalance: BigNumber;
          lastPing: BigNumber;
          id: BigNumber;
          backup: string;
          inheritors: string[];
        }
      ] & {
        info: [string, BigNumber, BigNumber, BigNumber, string, string[]] & {
          owner: string;
          weiBalance: BigNumber;
          lastPing: BigNumber;
          id: BigNumber;
          backup: string;
          inheritors: string[];
        };
      }
    >;

    ping(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    removeInheritors(
      _inheritors: string[],
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    transferBackup(
      _newBackupAddress: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    transferOwnership(
      _newVaultOwner: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;
  };

  addInheritors(
    _newInheritors: string[],
    _weiShare: BigNumberish[],
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  allEtherAllocations(
    overrides?: CallOverrides
  ): Promise<
    ([string, BigNumber] & { inheritor: string; weiAlloc: BigNumber })[]
  >;

  allocateERC1155Tokens(
    token: string,
    _inheritors: string[],
    _tokenIDs: BigNumberish[],
    _amounts: BigNumberish[],
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  allocateERC20Tokens(
    token: string,
    _inheritors: string[],
    _shares: BigNumberish[],
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  allocateERC721Tokens(
    token: string,
    _inheritors: string[],
    _tokenIDs: BigNumberish[],
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  allocateEther(
    _inheritors: string[],
    _ethShares: BigNumberish[],
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  claimAllAllocations(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  claimOwnership(
    _newBackupAddress: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  etherBalance(overrides?: CallOverrides): Promise<BigNumber>;

  getAllAllocatedERC1155Tokens(
    _inheritor: string,
    overrides?: CallOverrides
  ): Promise<
    ([string, BigNumber, BigNumber] & {
      token: string;
      tokenID: BigNumber;
      amount: BigNumber;
    })[]
  >;

  getAllocatedERC1155Tokens(
    _token: string,
    _inheritor: string,
    overrides?: CallOverrides
  ): Promise<
    ([BigNumber, BigNumber] & { tokenID: BigNumber; amount: BigNumber })[]
  >;

  getAllocatedERC20Tokens(
    _inheritor: string,
    overrides?: CallOverrides
  ): Promise<([string, BigNumber] & { token: string; amount: BigNumber })[]>;

  getAllocatedERC721TokenAddresses(
    _inheritor: string,
    overrides?: CallOverrides
  ): Promise<string[]>;

  getAllocatedERC721TokenIds(
    _inheritor: string,
    _token: string,
    overrides?: CallOverrides
  ): Promise<BigNumber[]>;

  getAllocatedERC721Tokens(
    _inheritor: string,
    overrides?: CallOverrides
  ): Promise<
    ([string, BigNumber[]] & { token: string; tokenIDs: BigNumber[] })[]
  >;

  getAllocatedEther(overrides?: CallOverrides): Promise<BigNumber>;

  getUnallocatedERC115Tokens(
    _token: string,
    _tokenId: BigNumberish,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  getUnallocatedEther(overrides?: CallOverrides): Promise<BigNumber>;

  getUnallocatedTokens(
    _token: string,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  inheritorERC20TokenAllocation(
    _inheritor: string,
    _token: string,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  inheritorEtherAllocation(
    _inheritor: string,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  inspectVault(
    overrides?: CallOverrides
  ): Promise<
    [string, BigNumber, BigNumber, BigNumber, string, string[]] & {
      owner: string;
      weiBalance: BigNumber;
      lastPing: BigNumber;
      id: BigNumber;
      backup: string;
      inheritors: string[];
    }
  >;

  ping(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  removeInheritors(
    _inheritors: string[],
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  transferBackup(
    _newBackupAddress: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  transferOwnership(
    _newVaultOwner: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    addInheritors(
      _newInheritors: string[],
      _weiShare: BigNumberish[],
      overrides?: CallOverrides
    ): Promise<void>;

    allEtherAllocations(
      overrides?: CallOverrides
    ): Promise<
      ([string, BigNumber] & { inheritor: string; weiAlloc: BigNumber })[]
    >;

    allocateERC1155Tokens(
      token: string,
      _inheritors: string[],
      _tokenIDs: BigNumberish[],
      _amounts: BigNumberish[],
      overrides?: CallOverrides
    ): Promise<void>;

    allocateERC20Tokens(
      token: string,
      _inheritors: string[],
      _shares: BigNumberish[],
      overrides?: CallOverrides
    ): Promise<void>;

    allocateERC721Tokens(
      token: string,
      _inheritors: string[],
      _tokenIDs: BigNumberish[],
      overrides?: CallOverrides
    ): Promise<void>;

    allocateEther(
      _inheritors: string[],
      _ethShares: BigNumberish[],
      overrides?: CallOverrides
    ): Promise<void>;

    claimAllAllocations(overrides?: CallOverrides): Promise<void>;

    claimOwnership(
      _newBackupAddress: string,
      overrides?: CallOverrides
    ): Promise<void>;

    etherBalance(overrides?: CallOverrides): Promise<BigNumber>;

    getAllAllocatedERC1155Tokens(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<
      ([string, BigNumber, BigNumber] & {
        token: string;
        tokenID: BigNumber;
        amount: BigNumber;
      })[]
    >;

    getAllocatedERC1155Tokens(
      _token: string,
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<
      ([BigNumber, BigNumber] & { tokenID: BigNumber; amount: BigNumber })[]
    >;

    getAllocatedERC20Tokens(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<([string, BigNumber] & { token: string; amount: BigNumber })[]>;

    getAllocatedERC721TokenAddresses(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<string[]>;

    getAllocatedERC721TokenIds(
      _inheritor: string,
      _token: string,
      overrides?: CallOverrides
    ): Promise<BigNumber[]>;

    getAllocatedERC721Tokens(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<
      ([string, BigNumber[]] & { token: string; tokenIDs: BigNumber[] })[]
    >;

    getAllocatedEther(overrides?: CallOverrides): Promise<BigNumber>;

    getUnallocatedERC115Tokens(
      _token: string,
      _tokenId: BigNumberish,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getUnallocatedEther(overrides?: CallOverrides): Promise<BigNumber>;

    getUnallocatedTokens(
      _token: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    inheritorERC20TokenAllocation(
      _inheritor: string,
      _token: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    inheritorEtherAllocation(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    inspectVault(
      overrides?: CallOverrides
    ): Promise<
      [string, BigNumber, BigNumber, BigNumber, string, string[]] & {
        owner: string;
        weiBalance: BigNumber;
        lastPing: BigNumber;
        id: BigNumber;
        backup: string;
        inheritors: string[];
      }
    >;

    ping(overrides?: CallOverrides): Promise<void>;

    removeInheritors(
      _inheritors: string[],
      overrides?: CallOverrides
    ): Promise<void>;

    transferBackup(
      _newBackupAddress: string,
      overrides?: CallOverrides
    ): Promise<void>;

    transferOwnership(
      _newVaultOwner: string,
      overrides?: CallOverrides
    ): Promise<void>;
  };

  filters: {};

  estimateGas: {
    addInheritors(
      _newInheritors: string[],
      _weiShare: BigNumberish[],
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    allEtherAllocations(overrides?: CallOverrides): Promise<BigNumber>;

    allocateERC1155Tokens(
      token: string,
      _inheritors: string[],
      _tokenIDs: BigNumberish[],
      _amounts: BigNumberish[],
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    allocateERC20Tokens(
      token: string,
      _inheritors: string[],
      _shares: BigNumberish[],
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    allocateERC721Tokens(
      token: string,
      _inheritors: string[],
      _tokenIDs: BigNumberish[],
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    allocateEther(
      _inheritors: string[],
      _ethShares: BigNumberish[],
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    claimAllAllocations(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    claimOwnership(
      _newBackupAddress: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    etherBalance(overrides?: CallOverrides): Promise<BigNumber>;

    getAllAllocatedERC1155Tokens(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getAllocatedERC1155Tokens(
      _token: string,
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getAllocatedERC20Tokens(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getAllocatedERC721TokenAddresses(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getAllocatedERC721TokenIds(
      _inheritor: string,
      _token: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getAllocatedERC721Tokens(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getAllocatedEther(overrides?: CallOverrides): Promise<BigNumber>;

    getUnallocatedERC115Tokens(
      _token: string,
      _tokenId: BigNumberish,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getUnallocatedEther(overrides?: CallOverrides): Promise<BigNumber>;

    getUnallocatedTokens(
      _token: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    inheritorERC20TokenAllocation(
      _inheritor: string,
      _token: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    inheritorEtherAllocation(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    inspectVault(overrides?: CallOverrides): Promise<BigNumber>;

    ping(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    removeInheritors(
      _inheritors: string[],
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    transferBackup(
      _newBackupAddress: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    transferOwnership(
      _newVaultOwner: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    addInheritors(
      _newInheritors: string[],
      _weiShare: BigNumberish[],
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    allEtherAllocations(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    allocateERC1155Tokens(
      token: string,
      _inheritors: string[],
      _tokenIDs: BigNumberish[],
      _amounts: BigNumberish[],
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    allocateERC20Tokens(
      token: string,
      _inheritors: string[],
      _shares: BigNumberish[],
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    allocateERC721Tokens(
      token: string,
      _inheritors: string[],
      _tokenIDs: BigNumberish[],
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    allocateEther(
      _inheritors: string[],
      _ethShares: BigNumberish[],
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    claimAllAllocations(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    claimOwnership(
      _newBackupAddress: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    etherBalance(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    getAllAllocatedERC1155Tokens(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getAllocatedERC1155Tokens(
      _token: string,
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getAllocatedERC20Tokens(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getAllocatedERC721TokenAddresses(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getAllocatedERC721TokenIds(
      _inheritor: string,
      _token: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getAllocatedERC721Tokens(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getAllocatedEther(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    getUnallocatedERC115Tokens(
      _token: string,
      _tokenId: BigNumberish,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getUnallocatedEther(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getUnallocatedTokens(
      _token: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    inheritorERC20TokenAllocation(
      _inheritor: string,
      _token: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    inheritorEtherAllocation(
      _inheritor: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    inspectVault(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    ping(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    removeInheritors(
      _inheritors: string[],
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    transferBackup(
      _newBackupAddress: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    transferOwnership(
      _newVaultOwner: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;
  };
}
