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
  CallOverrides,
} from "ethers";
import { BytesLike } from "@ethersproject/bytes";
import { Listener, Provider } from "@ethersproject/providers";
import { FunctionFragment, EventFragment, Result } from "@ethersproject/abi";
import type { TypedEventFilter, TypedEvent, TypedListener } from "./common";

interface IVaultDiamondInterface extends ethers.utils.Interface {
  functions: {
    "vaultFactoryDiamond()": FunctionFragment;
    "vaultOwner()": FunctionFragment;
  };

  encodeFunctionData(
    functionFragment: "vaultFactoryDiamond",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "vaultOwner",
    values?: undefined
  ): string;

  decodeFunctionResult(
    functionFragment: "vaultFactoryDiamond",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "vaultOwner", data: BytesLike): Result;

  events: {};
}

export class IVaultDiamond extends BaseContract {
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

  interface: IVaultDiamondInterface;

  functions: {
    vaultFactoryDiamond(overrides?: CallOverrides): Promise<[string]>;

    vaultOwner(overrides?: CallOverrides): Promise<[string]>;
  };

  vaultFactoryDiamond(overrides?: CallOverrides): Promise<string>;

  vaultOwner(overrides?: CallOverrides): Promise<string>;

  callStatic: {
    vaultFactoryDiamond(overrides?: CallOverrides): Promise<string>;

    vaultOwner(overrides?: CallOverrides): Promise<string>;
  };

  filters: {};

  estimateGas: {
    vaultFactoryDiamond(overrides?: CallOverrides): Promise<BigNumber>;

    vaultOwner(overrides?: CallOverrides): Promise<BigNumber>;
  };

  populateTransaction: {
    vaultFactoryDiamond(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    vaultOwner(overrides?: CallOverrides): Promise<PopulatedTransaction>;
  };
}
