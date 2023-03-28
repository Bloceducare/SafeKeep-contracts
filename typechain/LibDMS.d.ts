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
} from "ethers";
import { BytesLike } from "@ethersproject/bytes";
import { Listener, Provider } from "@ethersproject/providers";
import { FunctionFragment, EventFragment, Result } from "@ethersproject/abi";
import type { TypedEventFilter, TypedEvent, TypedListener } from "./common";

interface LibDMSInterface extends ethers.utils.Interface {
  functions: {};

  events: {
    "BackupTransferred(address,address,uint256)": EventFragment;
    "ERC1155TokensAllocated(address,address,uint256,uint256,uint256)": EventFragment;
    "ERC1155TokensClaimed(address,address,uint256,uint256,uint256)": EventFragment;
    "ERC20TokensAllocated(address,address[],uint256[],uint256)": EventFragment;
    "ERC20TokensClaimed(address,address,uint256,uint256)": EventFragment;
    "ERC721ErrorHandled(uint256,string)": EventFragment;
    "ERC721TokenClaimed(address,address,uint256,uint256)": EventFragment;
    "ERC721TokensAllocated(address,address,uint256,uint256)": EventFragment;
    "EthAllocated(address[],uint256[],uint256)": EventFragment;
    "EthClaimed(address,uint256,uint256)": EventFragment;
    "InheritorsAdded(address[],uint256)": EventFragment;
    "InheritorsRemoved(address[],uint256)": EventFragment;
    "OwnershipTransferred(address,address,uint256)": EventFragment;
    "VaultPinged(uint256,uint256)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "BackupTransferred"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "ERC1155TokensAllocated"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "ERC1155TokensClaimed"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "ERC20TokensAllocated"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "ERC20TokensClaimed"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "ERC721ErrorHandled"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "ERC721TokenClaimed"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "ERC721TokensAllocated"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "EthAllocated"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "EthClaimed"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "InheritorsAdded"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "InheritorsRemoved"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "OwnershipTransferred"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "VaultPinged"): EventFragment;
}

export type BackupTransferredEvent = TypedEvent<
  [string, string, BigNumber] & {
    previousBackup: string;
    newBackup: string;
    vaultID: BigNumber;
  }
>;

export type ERC1155TokensAllocatedEvent = TypedEvent<
  [string, string, BigNumber, BigNumber, BigNumber] & {
    token: string;
    inheritor: string;
    tokenID: BigNumber;
    amount: BigNumber;
    vaultID: BigNumber;
  }
>;

export type ERC1155TokensClaimedEvent = TypedEvent<
  [string, string, BigNumber, BigNumber, BigNumber] & {
    inheritor: string;
    token: string;
    tokenID: BigNumber;
    amount: BigNumber;
    vaultID: BigNumber;
  }
>;

export type ERC20TokensAllocatedEvent = TypedEvent<
  [string, string[], BigNumber[], BigNumber] & {
    token: string;
    inheritors: string[];
    amounts: BigNumber[];
    vaultID: BigNumber;
  }
>;

export type ERC20TokensClaimedEvent = TypedEvent<
  [string, string, BigNumber, BigNumber] & {
    inheritor: string;
    token: string;
    amount: BigNumber;
    vaultID: BigNumber;
  }
>;

export type ERC721ErrorHandledEvent = TypedEvent<
  [BigNumber, string] & { _failedTokenId: BigNumber; reason: string }
>;

export type ERC721TokenClaimedEvent = TypedEvent<
  [string, string, BigNumber, BigNumber] & {
    inheritor: string;
    token: string;
    tokenID: BigNumber;
    vaultID: BigNumber;
  }
>;

export type ERC721TokensAllocatedEvent = TypedEvent<
  [string, string, BigNumber, BigNumber] & {
    token: string;
    inheritor: string;
    tokenID: BigNumber;
    vaultID: BigNumber;
  }
>;

export type EthAllocatedEvent = TypedEvent<
  [string[], BigNumber[], BigNumber] & {
    inheritors: string[];
    amounts: BigNumber[];
    vaultID: BigNumber;
  }
>;

export type EthClaimedEvent = TypedEvent<
  [string, BigNumber, BigNumber] & {
    inheritor: string;
    _amount: BigNumber;
    vaultID: BigNumber;
  }
>;

export type InheritorsAddedEvent = TypedEvent<
  [string[], BigNumber] & { newInheritors: string[]; vaultID: BigNumber }
>;

export type InheritorsRemovedEvent = TypedEvent<
  [string[], BigNumber] & { inheritors: string[]; vaultID: BigNumber }
>;

export type OwnershipTransferredEvent = TypedEvent<
  [string, string, BigNumber] & {
    previousOwner: string;
    newOwner: string;
    vaultID: BigNumber;
  }
>;

export type VaultPingedEvent = TypedEvent<
  [BigNumber, BigNumber] & { lastPing: BigNumber; vaultID: BigNumber }
>;

export class LibDMS extends BaseContract {
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

  interface: LibDMSInterface;

  functions: {};

  callStatic: {};

  filters: {
    "BackupTransferred(address,address,uint256)"(
      previousBackup?: string | null,
      newBackup?: string | null,
      vaultID?: null
    ): TypedEventFilter<
      [string, string, BigNumber],
      { previousBackup: string; newBackup: string; vaultID: BigNumber }
    >;

    BackupTransferred(
      previousBackup?: string | null,
      newBackup?: string | null,
      vaultID?: null
    ): TypedEventFilter<
      [string, string, BigNumber],
      { previousBackup: string; newBackup: string; vaultID: BigNumber }
    >;

    "ERC1155TokensAllocated(address,address,uint256,uint256,uint256)"(
      token?: string | null,
      inheritor?: null,
      tokenID?: null,
      amount?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string, string, BigNumber, BigNumber, BigNumber],
      {
        token: string;
        inheritor: string;
        tokenID: BigNumber;
        amount: BigNumber;
        vaultID: BigNumber;
      }
    >;

    ERC1155TokensAllocated(
      token?: string | null,
      inheritor?: null,
      tokenID?: null,
      amount?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string, string, BigNumber, BigNumber, BigNumber],
      {
        token: string;
        inheritor: string;
        tokenID: BigNumber;
        amount: BigNumber;
        vaultID: BigNumber;
      }
    >;

    "ERC1155TokensClaimed(address,address,uint256,uint256,uint256)"(
      inheritor?: string | null,
      token?: string | null,
      tokenID?: null,
      amount?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string, string, BigNumber, BigNumber, BigNumber],
      {
        inheritor: string;
        token: string;
        tokenID: BigNumber;
        amount: BigNumber;
        vaultID: BigNumber;
      }
    >;

    ERC1155TokensClaimed(
      inheritor?: string | null,
      token?: string | null,
      tokenID?: null,
      amount?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string, string, BigNumber, BigNumber, BigNumber],
      {
        inheritor: string;
        token: string;
        tokenID: BigNumber;
        amount: BigNumber;
        vaultID: BigNumber;
      }
    >;

    "ERC20TokensAllocated(address,address[],uint256[],uint256)"(
      token?: string | null,
      inheritors?: null,
      amounts?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string, string[], BigNumber[], BigNumber],
      {
        token: string;
        inheritors: string[];
        amounts: BigNumber[];
        vaultID: BigNumber;
      }
    >;

    ERC20TokensAllocated(
      token?: string | null,
      inheritors?: null,
      amounts?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string, string[], BigNumber[], BigNumber],
      {
        token: string;
        inheritors: string[];
        amounts: BigNumber[];
        vaultID: BigNumber;
      }
    >;

    "ERC20TokensClaimed(address,address,uint256,uint256)"(
      inheritor?: string | null,
      token?: string | null,
      amount?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string, string, BigNumber, BigNumber],
      {
        inheritor: string;
        token: string;
        amount: BigNumber;
        vaultID: BigNumber;
      }
    >;

    ERC20TokensClaimed(
      inheritor?: string | null,
      token?: string | null,
      amount?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string, string, BigNumber, BigNumber],
      {
        inheritor: string;
        token: string;
        amount: BigNumber;
        vaultID: BigNumber;
      }
    >;

    "ERC721ErrorHandled(uint256,string)"(
      _failedTokenId?: null,
      reason?: null
    ): TypedEventFilter<
      [BigNumber, string],
      { _failedTokenId: BigNumber; reason: string }
    >;

    ERC721ErrorHandled(
      _failedTokenId?: null,
      reason?: null
    ): TypedEventFilter<
      [BigNumber, string],
      { _failedTokenId: BigNumber; reason: string }
    >;

    "ERC721TokenClaimed(address,address,uint256,uint256)"(
      inheritor?: string | null,
      token?: string | null,
      tokenID?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string, string, BigNumber, BigNumber],
      {
        inheritor: string;
        token: string;
        tokenID: BigNumber;
        vaultID: BigNumber;
      }
    >;

    ERC721TokenClaimed(
      inheritor?: string | null,
      token?: string | null,
      tokenID?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string, string, BigNumber, BigNumber],
      {
        inheritor: string;
        token: string;
        tokenID: BigNumber;
        vaultID: BigNumber;
      }
    >;

    "ERC721TokensAllocated(address,address,uint256,uint256)"(
      token?: string | null,
      inheritor?: null,
      tokenID?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string, string, BigNumber, BigNumber],
      {
        token: string;
        inheritor: string;
        tokenID: BigNumber;
        vaultID: BigNumber;
      }
    >;

    ERC721TokensAllocated(
      token?: string | null,
      inheritor?: null,
      tokenID?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string, string, BigNumber, BigNumber],
      {
        token: string;
        inheritor: string;
        tokenID: BigNumber;
        vaultID: BigNumber;
      }
    >;

    "EthAllocated(address[],uint256[],uint256)"(
      inheritors?: null,
      amounts?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string[], BigNumber[], BigNumber],
      { inheritors: string[]; amounts: BigNumber[]; vaultID: BigNumber }
    >;

    EthAllocated(
      inheritors?: null,
      amounts?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string[], BigNumber[], BigNumber],
      { inheritors: string[]; amounts: BigNumber[]; vaultID: BigNumber }
    >;

    "EthClaimed(address,uint256,uint256)"(
      inheritor?: string | null,
      _amount?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string, BigNumber, BigNumber],
      { inheritor: string; _amount: BigNumber; vaultID: BigNumber }
    >;

    EthClaimed(
      inheritor?: string | null,
      _amount?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string, BigNumber, BigNumber],
      { inheritor: string; _amount: BigNumber; vaultID: BigNumber }
    >;

    "InheritorsAdded(address[],uint256)"(
      newInheritors?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string[], BigNumber],
      { newInheritors: string[]; vaultID: BigNumber }
    >;

    InheritorsAdded(
      newInheritors?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string[], BigNumber],
      { newInheritors: string[]; vaultID: BigNumber }
    >;

    "InheritorsRemoved(address[],uint256)"(
      inheritors?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string[], BigNumber],
      { inheritors: string[]; vaultID: BigNumber }
    >;

    InheritorsRemoved(
      inheritors?: null,
      vaultID?: null
    ): TypedEventFilter<
      [string[], BigNumber],
      { inheritors: string[]; vaultID: BigNumber }
    >;

    "OwnershipTransferred(address,address,uint256)"(
      previousOwner?: string | null,
      newOwner?: string | null,
      vaultID?: null
    ): TypedEventFilter<
      [string, string, BigNumber],
      { previousOwner: string; newOwner: string; vaultID: BigNumber }
    >;

    OwnershipTransferred(
      previousOwner?: string | null,
      newOwner?: string | null,
      vaultID?: null
    ): TypedEventFilter<
      [string, string, BigNumber],
      { previousOwner: string; newOwner: string; vaultID: BigNumber }
    >;

    "VaultPinged(uint256,uint256)"(
      lastPing?: null,
      vaultID?: null
    ): TypedEventFilter<
      [BigNumber, BigNumber],
      { lastPing: BigNumber; vaultID: BigNumber }
    >;

    VaultPinged(
      lastPing?: null,
      vaultID?: null
    ): TypedEventFilter<
      [BigNumber, BigNumber],
      { lastPing: BigNumber; vaultID: BigNumber }
    >;
  };

  estimateGas: {};

  populateTransaction: {};
}
