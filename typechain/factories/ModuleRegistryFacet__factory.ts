/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import { Provider, TransactionRequest } from "@ethersproject/providers";
import type {
  ModuleRegistryFacet,
  ModuleRegistryFacetInterface,
} from "../ModuleRegistryFacet";

const _abi = [
  {
    inputs: [
      {
        internalType: "string",
        name: "moduleName",
        type: "string",
      },
    ],
    name: "ModuleExists",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "moduleName",
        type: "string",
      },
    ],
    name: "NonExistentModule",
    type: "error",
  },
  {
    inputs: [],
    name: "NotDiamondOwner",
    type: "error",
  },
  {
    inputs: [
      {
        components: [
          {
            components: [
              {
                internalType: "address",
                name: "facetAddress",
                type: "address",
              },
              {
                internalType: "enum IDiamondCut.FacetCutAction",
                name: "action",
                type: "uint8",
              },
              {
                internalType: "bytes4[]",
                name: "functionSelectors",
                type: "bytes4[]",
              },
            ],
            internalType: "struct IDiamondCut.FacetCut[]",
            name: "facetData",
            type: "tuple[]",
          },
          {
            internalType: "bytes32",
            name: "slot",
            type: "bytes32",
          },
          {
            internalType: "uint256",
            name: "timeAdded",
            type: "uint256",
          },
          {
            internalType: "string[]",
            name: "facetNames",
            type: "string[]",
          },
        ],
        internalType: "struct IModuleData.ModuleData[]",
        name: "_modules",
        type: "tuple[]",
      },
      {
        internalType: "string[]",
        name: "_names",
        type: "string[]",
      },
    ],
    name: "addModules",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "_name",
        type: "string",
      },
    ],
    name: "getFacetCuts",
    outputs: [
      {
        components: [
          {
            internalType: "address",
            name: "facetAddress",
            type: "address",
          },
          {
            internalType: "enum IDiamondCut.FacetCutAction",
            name: "action",
            type: "uint8",
          },
          {
            internalType: "bytes4[]",
            name: "functionSelectors",
            type: "bytes4[]",
          },
        ],
        internalType: "struct IDiamondCut.FacetCut[]",
        name: "cuts_",
        type: "tuple[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "_name",
        type: "string",
      },
    ],
    name: "getModule",
    outputs: [
      {
        components: [
          {
            components: [
              {
                internalType: "address",
                name: "facetAddress",
                type: "address",
              },
              {
                internalType: "enum IDiamondCut.FacetCutAction",
                name: "action",
                type: "uint8",
              },
              {
                internalType: "bytes4[]",
                name: "functionSelectors",
                type: "bytes4[]",
              },
            ],
            internalType: "struct IDiamondCut.FacetCut[]",
            name: "facetData",
            type: "tuple[]",
          },
          {
            internalType: "bytes32",
            name: "slot",
            type: "bytes32",
          },
          {
            internalType: "uint256",
            name: "timeAdded",
            type: "uint256",
          },
          {
            internalType: "string[]",
            name: "facetNames",
            type: "string[]",
          },
        ],
        internalType: "struct IModuleData.ModuleData",
        name: "module_",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string[]",
        name: "_names",
        type: "string[]",
      },
    ],
    name: "getModules",
    outputs: [
      {
        components: [
          {
            components: [
              {
                internalType: "address",
                name: "facetAddress",
                type: "address",
              },
              {
                internalType: "enum IDiamondCut.FacetCutAction",
                name: "action",
                type: "uint8",
              },
              {
                internalType: "bytes4[]",
                name: "functionSelectors",
                type: "bytes4[]",
              },
            ],
            internalType: "struct IDiamondCut.FacetCut[]",
            name: "facetData",
            type: "tuple[]",
          },
          {
            internalType: "bytes32",
            name: "slot",
            type: "bytes32",
          },
          {
            internalType: "uint256",
            name: "timeAdded",
            type: "uint256",
          },
          {
            internalType: "string[]",
            name: "facetNames",
            type: "string[]",
          },
        ],
        internalType: "struct IModuleData.ModuleData[]",
        name: "modules_",
        type: "tuple[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "_name",
        type: "string",
      },
    ],
    name: "moduleExists",
    outputs: [
      {
        internalType: "bool",
        name: "exists_",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

const _bytecode =
  "0x608060405234801561001057600080fd5b506117e8806100206000396000f3fe608060405234801561001057600080fd5b50600436106100575760003560e01c806308f523d81461005c5780632373bc70146100855780634f764e49146100a5578063aaf1f07a146100c5578063fc5589f4146100da575b600080fd5b61006f61006a366004610b82565b6100fd565b60405161007c919061107e565b60405180910390f35b610098610093366004610adb565b610171565b60405161007c9190610eb7565b6100b86100b3366004610bee565b610185565b60405161007c9190610ea4565b6100d86100d3366004610b1a565b610196565b005b6100ed6100e8366004610b82565b6101a8565b604051901515815260200161007c565b61012b6040518060800160405280606081526020016000801916815260200160008152602001606081525090565b61016a83838080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920191909152506101e992505050565b9392505050565b606061016a61018083856111d6565b6104ab565b6060610190826105b6565b92915050565b6101a284848484610763565b50505050565b600061016a83838080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525061099d92505050565b6102176040518060800160405280606081526020016000801916815260200160008152602001606081525090565b600080816001018460405161022c9190610e88565b90815260405190819003602001902080549091506102685783604051630dcde19d60e41b815260040161025f9190610f2c565b60405180910390fd5b60408051825460a0602082028301810190935260808201818152919284928492909184919060009085015b828210156103ae5760008481526020908190206040805160608101909152600285810290920180546001600160a01b03811683529193909290840191600160a01b900460ff16908111156102f757634e487b7160e01b600052602160045260246000fd5b600281111561031657634e487b7160e01b600052602160045260246000fd5b81526020016001820180548060200260200160405190810160405280929190818152602001828054801561039657602002820191906000526020600020906000905b82829054906101000a900460e01b6001600160e01b031916815260200190600401906020826003010492830192600103820291508084116103585790505b50505050508152505081526020019060010190610293565b505050508152602001600182015481526020016002820154815260200160038201805480602002602001604051908101604052809291908181526020016000905b8282101561049b57838290600052602060002001805461040e90611368565b80601f016020809104026020016040519081016040528092919081815260200182805461043a90611368565b80156104875780601f1061045c57610100808354040283529160200191610487565b820191906000526020600020905b81548152906001019060200180831161046a57829003601f168201915b5050505050815260200190600101906103ef565b5050509152509095945050505050565b606081516001600160401b038111156104d457634e487b7160e01b600052604160045260246000fd5b60405190808252806020026020018201604052801561053357816020015b6105206040518060800160405280606081526020016000801916815260200160008152602001606081525090565b8152602001906001900390816104f25790505b50905060005b82518110156105b05761057283828151811061056557634e487b7160e01b600052603260045260246000fd5b60200260200101516101e9565b82828151811061059257634e487b7160e01b600052603260045260246000fd5b602002602001018190525080806105a89061139d565b915050610539565b50919050565b606060008081600101846040516105cd9190610e88565b90815260405190819003602001902080549091506106005783604051630dcde19d60e41b815260040161025f9190610f2c565b81600101846040516106129190610e88565b908152604080519182900360209081018320805480830285018301909352828452919060009084015b828210156107565760008481526020908190206040805160608101909152600285810290920180546001600160a01b03811683529193909290840191600160a01b900460ff169081111561069f57634e487b7160e01b600052602160045260246000fd5b60028111156106be57634e487b7160e01b600052602160045260246000fd5b81526020016001820180548060200260200160405190810160405280929190818152602001828054801561073e57602002820191906000526020600020906000905b82829054906101000a900460e01b6001600160e01b031916815260200190600401906020826003010492830192600103820291508084116107005790505b5050505050815250508152602001906001019061063b565b5050505092505050919050565b82811461078057634e487b7160e01b600052600160045260246000fd5b6107886109d9565b6000805b84811015610995576000826001018585848181106107ba57634e487b7160e01b600052603260045260246000fd5b90506020028101906107cc91906110d8565b6040516107da929190610e78565b9081526040519081900360200190208054909150156108405784848381811061081357634e487b7160e01b600052603260045260246000fd5b905060200281019061082591906110d8565b60405163c9508a0d60e01b815260040161025f929190610f18565b86868381811061086057634e487b7160e01b600052603260045260246000fd5b90506020028101906108729190611131565b8360010186868581811061089657634e487b7160e01b600052603260045260246000fd5b90506020028101906108a891906110d8565b6040516108b6929190610e78565b9081526040519081900360200190206108cf8282611410565b9050508484838181106108f257634e487b7160e01b600052603260045260246000fd5b905060200281019061090491906110d8565b604051610912929190610e78565b60405180910390207f4c244b0f7505994bca14c7e68f815945b79b967336544af767dc71b89ecd62a788888581811061095b57634e487b7160e01b600052603260045260246000fd5b905060200281019061096d9190611131565b60405161097a9190610f3f565b60405180910390a2508061098d8161139d565b91505061078c565b505050505050565b600080600081600101846040516109b49190610e88565b9081526040519081900360200190208054909150156109d257600192505b5050919050565b7ff0012a687af7752843524cd4908ddea76b8cf30b148d95b1684517391251d00d600401546001600160a01b03163314610a2657604051630305808160e41b815260040160405180910390fd5b565b60008083601f840112610a39578182fd5b5081356001600160401b03811115610a4f578182fd5b6020830191508360208260051b8501011115610a6a57600080fd5b9250929050565b600082601f830112610a81578081fd5b81356001600160401b03811115610a9a57610a9a6113ce565b610aad601f8201601f1916602001611146565b818152846020838601011115610ac1578283fd5b816020850160208301379081016020019190915292915050565b60008060208385031215610aed578182fd5b82356001600160401b03811115610b02578283fd5b610b0e85828601610a28565b90969095509350505050565b60008060008060408587031215610b2f578182fd5b84356001600160401b0380821115610b45578384fd5b610b5188838901610a28565b90965094506020870135915080821115610b69578384fd5b50610b7687828801610a28565b95989497509550505050565b60008060208385031215610b94578182fd5b82356001600160401b0380821115610baa578384fd5b818501915085601f830112610bbd578384fd5b813581811115610bcb578485fd5b866020828501011115610bdc578485fd5b60209290920196919550909350505050565b600060208284031215610bff578081fd5b81356001600160401b03811115610c14578182fd5b610c2084828501610a71565b949350505050565b60008383855260208086019550808560051b83010184845b87811015610cab57848303601f19018952813536889003601e19018112610c65578687fd5b870180356001600160401b03811115610c7c578788fd5b803603891315610c8a578788fd5b610c978582888501610d96565b9a86019a9450505090830190600101610c40565b5090979650505050505050565b600081518084526020808501808196508360051b81019150828601855b85811015610d67578284038952815180516001600160a01b031685528581015160609081870190610d0889890182610d74565b506040928301519287019190915281519081905290860190608086019089905b80821015610d525783516001600160e01b0319168352928801929188019160019190910190610d28565b50509986019994505090840190600101610cd5565b5091979650505050505050565b60038110610d9257634e487b7160e01b600052602160045260246000fd5b9052565b81835281816020850137506000828201602090810191909152601f909101601f19169091010190565b60008151808452610dd781602086016020860161133c565b601f01601f19169290920160200192915050565b6000815160808452610e006080850182610cb8565b90506020808401518186015260408401516040860152606084015185830360608701528281518085528385019150838160051b8601018484019350865b82811015610e6b57601f19878303018452610e59828651610dbf565b94860194938601939150600101610e3d565b5098975050505050505050565b8183823760009101908152919050565b60008251610e9a81846020870161133c565b9190910192915050565b60208152600061016a6020830184610cb8565b6000602080830181845280855180835260408601915060408160051b8701019250838701855b82811015610f0b57603f19888603018452610ef9858351610deb565b94509285019290850190600101610edd565b5092979650505050505050565b602081526000610c20602083018486610d96565b60208152600061016a6020830184610dbf565b6000602080835260a08301610f548586611176565b608080858801528382855260c08801905060c08360051b890101945083875b848110156110355789870360bf19018352813536879003605e19018112610f9857898afd5b860160608881018235610faa81611777565b6001600160a01b03168a52828b0135610fc2816117a5565b610fce8c8c0182610d74565b506040610fdd81850185611176565b918c0193909352908190529150858901908b5b8381101561101f5781356110038161178f565b6001600160e01b0319168352918b0191908b0190600101610ff0565b5090985050509187019190870190600101610f73565b505050848801356040880152604088013560608801526110586060890189611176565b95509250601f1987850301818801525050611074828483610c28565b9695505050505050565b60208152600061016a6020830184610deb565b6000808335601e198436030181126110a7578283fd5b8301803591506001600160401b038211156110c0578283fd5b6020019150600581901b3603821315610a6a57600080fd5b6000808335601e198436030181126110ee578182fd5b8301803591506001600160401b03821115611107578283fd5b602001915036819003821315610a6a57600080fd5b60008235605e19833603018112610e9a578182fd5b60008235607e19833603018112610e9a578182fd5b604051601f8201601f191681016001600160401b038111828210171561116e5761116e6113ce565b604052919050565b6000808335601e1984360301811261118c578283fd5b83016020810192503590506001600160401b038111156111ab57600080fd5b8060051b3603831315610a6a57600080fd5b5b818110156111d257600081556001016111be565b5050565b60006001600160401b03808411156111f0576111f06113ce565b8360051b6020611201818301611146565b8681528181019086368582011115611217578687fd5b8694505b8885101561125257803586811115611231578788fd5b61123d36828b01610a71565b8452506001949094019391830191830161121b565b50979650505050505050565b600160401b831115611272576112726113ce565b8054838255808410156112fd576000828152602090208481019082015b808210156112fa5781546112a281611368565b80156112ed57601f808211600181146112be57600086556112ea565b6000868152602090206112db83850160051c8201600183016111bd565b50600086815260208120818855555b50505b505060018201915061128f565b50505b5060008181526020812083915b858110156109955761131c83866110d8565b611327818386611518565b5050602092909201916001918201910161130a565b60005b8381101561135757818101518382015260200161133f565b838111156101a25750506000910152565b600181811c9082168061137c57607f821691505b602082108114156105b057634e487b7160e01b600052602260045260246000fd5b60006000198214156113b1576113b16113b8565b5060010190565b634e487b7160e01b600052601160045260246000fd5b634e487b7160e01b600052604160045260246000fd5b80546000825580156111d25781600052602060002061140b6007830160031c8201826111bd565b505050565b61141a8283611091565b600160401b81111561142e5761142e6113ce565b8254818455808210156114a6576001600160ff1b036001818311811615611457576114576113b8565b818411811615611469576114696113b8565b60008681526020812090925084821b81019084831b015b808210156114a1578382556114968383016113e4565b600282019150611480565b505050505b5060008381526020812083915b838110156114e4576114ce6114c8848761111c565b83611617565b60209290920191600291909101906001016114b3565b5050505050602082013560018201556040820135600282015561150a6060830183611091565b6101a281836003860161125e565b6001600160401b0383111561152f5761152f6113ce565b6115398154611368565b600080601f8611601f8411818117156115585760008681526020902092505b801561158757601f880160051c830160208910156115735750825b611585601f870160051c8501826111bd565b505b5080600181146115bb576000945087156115a2578387013594505b600188901b60001960038a901b1c19861617865561160d565b601f198816945082845b868110156115e557888601358255602095860195600190920191016115c5565b50888610156116025760001960f88a60031b161c19858901351681555b5060018860011b0186555b5050505050505050565b813561162281611777565b81546001600160a01b031981166001600160a01b0392909216918217835560208481013561164f816117a5565b600380821061166e57634e487b7160e01b600052602160045260246000fd5b6001600160a81b03199390931690931760a084901b60ff60a01b16178455600192838501926116a06040880188611091565b9250600160401b8311156116b6576116b66113ce565b84548386558084101561170a57856000528460002060078501841c8101601c8660021b1680156116f557600019808301805482848c038a1b1c16815550505b5061170760078401861c8301826111bd565b50505b5060009485528385209480805b8581101561176a57833561172a8161178f565b885463ffffffff84881b90811b801990921660e09390931c901b1617885592860192600490910190601c82111561176357968801968291505b8801611717565b5050505050505050505050565b6001600160a01b038116811461178c57600080fd5b50565b6001600160e01b03198116811461178c57600080fd5b6003811061178c57600080fdfea26469706673582212204ff7e65a53c8b630dc914385b33dfe1ea5b6326815ef79527d6f36e7bdb8136164736f6c63430008040033";

export class ModuleRegistryFacet__factory extends ContractFactory {
  constructor(
    ...args: [signer: Signer] | ConstructorParameters<typeof ContractFactory>
  ) {
    if (args.length === 1) {
      super(_abi, _bytecode, args[0]);
    } else {
      super(...args);
    }
  }

  deploy(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ModuleRegistryFacet> {
    return super.deploy(overrides || {}) as Promise<ModuleRegistryFacet>;
  }
  getDeployTransaction(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  attach(address: string): ModuleRegistryFacet {
    return super.attach(address) as ModuleRegistryFacet;
  }
  connect(signer: Signer): ModuleRegistryFacet__factory {
    return super.connect(signer) as ModuleRegistryFacet__factory;
  }
  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): ModuleRegistryFacetInterface {
    return new utils.Interface(_abi) as ModuleRegistryFacetInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): ModuleRegistryFacet {
    return new Contract(address, _abi, signerOrProvider) as ModuleRegistryFacet;
  }
}
