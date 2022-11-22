# SafeKeep

Repo for safekeep finance containing all contract components

# SafeKeep General Overview

A smart contract wallet called **SafeKeep** is used to store, send, and receive cryptocurrency assets. It also helps prevent the loss of money over the long term. In cases of unanticipated events like wallet loss, owner death, compromised wallets, etc., Safekeep recovers funds.

The endless capabilities that can be introduced to safeKeep in the future to suit new features in the blockchain realm are what I find most intriguing about it. When a vault owner decides he no longer needs a certain function, he can downgrade it from his vault as well. These features are referred to as modules and can be installed into each vault at his discretion.

## The technicality of building safeKeep:

The eip2535 standard was used in the construction of SafeKeep, providing the option for a robust design. Two Sections make up the majority of the safeKeep architecture.

Factory contract architecture for diamonds (EIP2535).

Diamond(Eip2535) Vault architecture to be spawned by the Diamond factory contract specified above.

# Further Detailed information on the architecture

# Diamond Factory Contract:

This multisig owned contract manages the distribution of the vault contract to users, which is done in the **vaultSpawnerFacet.sol**, and it also includes the functionality to register and unregistered modules, which is done in the **ModuleRegistry.sol**.

Every user of safekeep will have a vault assigned to them (more on vaults below), and they will be in complete control of the management and upkeep of each vault as the vaultOwner.

The **ModuleRegistry** features deal with the register of additional functionality a vault may possess but may not have been offered at the time the Diamond contract was deployed (ability to upgrade contract without changing contract address is made possible with the eip2535 standard.) The safeKeep project became a forward-thinking project with the architecture to add further features as a result of this functionality.

Other facets in the factory diamond include DiamondLoupeFacet, which is a tool used to inspect all supported and available facets and functions in a diamond, and DiamondCut Facet, which contains the logic that helps to add, remove, and replace functions and facets to be upgraded.

# The Vault Architecture.

We will explore each facet and comprehend the operation of each module as well as the rationale behind the core service that safeKeep offers, which is handled in the vault diamond.

# Comprehensive comprehension of a module.

The purpose of modules is to allow users to upgrade and downgrade any features in their vault without having to upgrade the entire vault or interfere with the slot storage of other existing vaults. Modules are a feature that exists in safekeep to allow users to separate slot storage of data in the vault for different features of safekeep. The eip2535 standard makes it feasible to add and remove new features from a Diamond contract without having to upgrade the entire system. Diamond has made modular upgrade possible because you don't need to change the entire system for a small upgrade needed.

        A module DataType in safekeep consist of the following data:

        — facetData; /array of facet data; IDiamondCut.FacetCut

        — bytes32 slot;/location of storage

        — uint256 timeAdded; /keccak hash of the relevant factors

        — string[] facetNames; /names of the involved facets in human readable form.

        Every module consists of the data layout mentioned above, which makes it simple to add and remove modules from storage.
        IDiamondCut.FacetCut[] is a struct type that has an address that represents the contract (referred to as a facet in Diamond) you want to conduct an action with, The action you want to execute is an enum with the options add, remove, and replace called action, and an array of bytes 4 (function selectors) located in the contract address. DiamondCut will upgrade your vault diamond using these details.

## The current state of each vault consist of 3 modules every users can have which are:

<!-- ## Current Modules and the facets in each module. -->

- Selector

  - DiamondCutFacet
  - DiamondLoupeFacet
  - OwnershipFacet
  - ModuleManagerFacet

- Token

  - ERC20Facet
  - ERC721Facet
  - ERC1155Facet
  - EtherFacet

- DMS (aka Dead Man Switch)

  - DMSFacet

  ## selector Module:

The vaultDiamond's upgradeability is handled by the selector module, which is a very necessary module having the following facets:

The DiamondcutFacet handles the addition and removal of various functions and facets from the vault diamond. Utilizing the diamondcutfacet aids the vault owner in performing upgradeability tasks.

In order for users or other vault stakeholders to know what function they can call in the Vault Diamond, the DiamondLoupeFacet assists in determining which facet, function selectors are supported in a vaultDiamond.

\_\_ OwnershipFacet: This facet has the logic that checks the owner of a vaultDiamond, it helps to find out and return the address of the vault owner.

\_\_ The \_\_ModuleManagerFacet verifies whether a module is present, retrieves the supported modules, and gives the vaultowner the option to upgrade and downgrade the module. Users can directly interact with its function signature to add and delete modules from a vault diamond.

The way that ModuleMAnagerFacet handles module upgrades is different from DiamondCutFacet in that it calls DiamondCutFacet to carry out the operation facet by facet in the ModuleData that is supplied to it.

## Token Module.

The Token Module manages token-related functions, including receiving and transmitting tokens into and out of the vault. This feature of safeKeep acts as a wallet for users; just like with metamask, trustwallet, or any other decentralized wallet you can think of, you may store your cryptocurrency in the vault and withdraw it whenever you need to. Additionally, users are required to have this module in their vault because it adds to the minimal functionality required for a vault to operate as a user's wallet. The token module includes the following facets:

ERC20Facet: This facet manages the logic required to carry out transactions for any ERC20 token type.

\_\_ERC721Facet: ERC721Facet is a facet manages the logic required to carry out transactions for any ERC721 token type.

\_\_ERC1155Facet: ERC1155Facet is a facet manages the logic required to carry out transactions for any ERC1155 token type.

\_\_EtherFacet: This facet manages the logic required to conduct transactions using the native coin of the blockchain.

## Dead Man Switch(DMS) Module.

The DMSFacet facet, which is part of the Dead Man Switch Module, manages the logic that permits the cryptocurrencies in a vault to be distributed to others.
The term "dead Man Switch" refers to the component of safeKeep that involves recovery.
 just in case anything unexpected happens. It offers features like assigning assets to others to withdraw only after a fair period of inactivity from the vault, utilizing the backup address provided to claim new owner of vault when existing ownership is being compromised, and this is where cryptocurrencies can be inherited when owner dies.

        After you pass away, your cryptoasset will be distributed to your inheritors, preventing it from getting stranded on the blockchain indefinitely.
