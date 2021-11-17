Sūrya's Description Report

Files Description Table

| File Name                                                                                     | SHA-1 Hash                               |
| --------------------------------------------------------------------------------------------- | ---------------------------------------- |
| /home/null/Desktop/SafeKeep/contracts/SafeKeep.sol                                            | a2c88e8b5e7d2a8a874d946bbda55d5e582083ae |
| /home/null/Desktop/SafeKeep/node_modules/@openzeppelin/contracts/access/Ownable.sol           | cf97dfd7970a708ff360201e645af1b4bf78f075 |
| /home/null/Desktop/SafeKeep/node_modules/@openzeppelin/contracts/utils/Context.sol            | 6cfff49179d5dd82ffa43390ff6ea2967ff6fa99 |
| /home/null/Desktop/SafeKeep/node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol      | e57edc94b81cdf7eac1e96deb723e3523771d6ed |
| /home/null/Desktop/SafeKeep/node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol       | 2a16c581fa3e71c55f5a07d494a1d6c4f937e6eb |
| /home/null/Desktop/SafeKeep/node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol | 6372eddb504565dc1944c647c13c075cffcaa2f7 |

Contracts Description Table

|      Contract       |             Type             |          Bases           |                |                                    |
| :-----------------: | :--------------------------: | :----------------------: | :------------: | :--------------------------------: |
|          └          |      **Function Name**       |      **Visibility**      | **Mutability** |           **Modifiers**            |
|                     |                              |                          |                |                                    |
|    **SafeKeep**     |        Implementation        | Ownable, ReentrancyGuard |                |                                    |
|          └          |       <Receive Ether>        |       External ❗️       |       💵       |               NO❗️                |
|          └          |          checkVault          |        Public ❗️        |                |               NO❗️                |
|          └          | checkAddressTokenAllocations |        Public ❗️        |                |               NO❗️                |
|          └          |       checkOwnerVault        |        Public ❗️        |                |               NO❗️                |
|          └          |   checkAllEtherAllocations   |        Public ❗️        |                |               NO❗️                |
|          └          |  checkBackupAddressAndPing   |        Public ❗️        |                |            vaultExists             |
|          └          | checkAddressEtherAllocation  |        Public ❗️        |                |            vaultExists             |
|          └          |    checkAllAddressVaults     |        Public ❗️        |                |               NO❗️                |
|          └          |    checkVaultEtherBalance    |        Public ❗️        |                |            vaultExists             |
|          └          |    checkVaultTokenBalance    |        Public ❗️        |                |               NO❗️                |
|          └          |   checkMyVaultTokenBalance   |        Public ❗️        |                |               NO❗️                |
|          └          |  checkAllVaultTokenBalances  |        Public ❗️        |                |               NO❗️                |
|          └          |  checkVaultDepositedTokens   |        Public ❗️        |                |               NO❗️                |
|          └          |       getAllInheritors       |        Public ❗️        |                |               NO❗️                |
|          └          |         createVault          |        Public ❗️        |       💵       |               NO❗️                |
|          └          |        addInheritors         |       External ❗️       |       🛑       |             notExpired             |
|          └          |       removeInheritors       |       External ❗️       |       🛑       |             notExpired             |
|          └          |         depositEther         |       External ❗️       |       💵       | vaultOwner notExpired nonReentrant |
|          └          |        depositTokens         |       External ❗️       |       🛑       | vaultOwner notExpired nonReentrant |
|          └          |        allocateTokens        |       External ❗️       |       🛑       |            nonReentrant            |
|          └          |        allocateEther         |       External ❗️       |       🛑       |            nonReentrant            |
|          └          |        checkEthLimit         |       Internal 🔒        |                |                                    |
|          └          |       checkTokenLimit        |       Internal 🔒        |                |                                    |
|          └          |         findAddIndex         |       Internal 🔒        |                |                                    |
|          └          |        findUintIndex         |       Internal 🔒        |                |                                    |
|          └          |          removeUint          |       Internal 🔒        |       🛑       |                                    |
|          └          |        removeAddress         |       Internal 🔒        |       🛑       |                                    |
|          └          |            reset             |       Internal 🔒        |       🛑       |                                    |
|          └          |    getCurrentAllocatedEth    |       Internal 🔒        |                |                                    |
|          └          |  getCurrentAllocatedTokens   |       Internal 🔒        |                |                                    |
|          └          |         withdrawEth          |        Public ❗️        |       🛑       |      vaultOwner nonReentrant       |
|          └          |        withdrawTokens        |        Public ❗️        |       🛑       |      vaultOwner nonReentrant       |
|          └          |            \_ping            |        Private 🔐        |       🛑       |             vaultOwner             |
|          └          |             ping             |       External ❗️       |       🛑       |               NO❗️                |
|          └          |         anInheritor          |       Internal 🔒        |                |                                    |
|          └          |        transferOwner         |        Public ❗️        |       🛑       |             vaultOwner             |
|          └          |        transferBackup        |        Public ❗️        |       🛑       |            vaultBackup             |
|          └          |        claimOwnership        |        Public ❗️        |       🛑       |            vaultBackup             |
|          └          |        claimAllTokens        |       Internal 🔒        |       🛑       |                                    |
|          └          |            claim             |       External ❗️       |       🛑       |            nonReentrant            |
|                     |                              |                          |                |                                    |
|     **Ownable**     |        Implementation        |         Context          |                |                                    |
|          └          |        <Constructor>         |        Public ❗️        |       🛑       |               NO❗️                |
|          └          |            owner             |        Public ❗️        |                |               NO❗️                |
|          └          |      renounceOwnership       |        Public ❗️        |       🛑       |             onlyOwner              |
|          └          |      transferOwnership       |        Public ❗️        |       🛑       |             onlyOwner              |
|          └          |          \_setOwner          |        Private 🔐        |       🛑       |                                    |
|                     |                              |                          |                |                                    |
|     **Context**     |        Implementation        |                          |                |                                    |
|          └          |         \_msgSender          |       Internal 🔒        |                |                                    |
|          └          |          \_msgData           |       Internal 🔒        |                |                                    |
|                     |                              |                          |                |                                    |
|    **SafeMath**     |           Library            |                          |                |                                    |
|          └          |            tryAdd            |       Internal 🔒        |                |                                    |
|          └          |            trySub            |       Internal 🔒        |                |                                    |
|          └          |            tryMul            |       Internal 🔒        |                |                                    |
|          └          |            tryDiv            |       Internal 🔒        |                |                                    |
|          └          |            tryMod            |       Internal 🔒        |                |                                    |
|          └          |             add              |       Internal 🔒        |                |                                    |
|          └          |             sub              |       Internal 🔒        |                |                                    |
|          └          |             mul              |       Internal 🔒        |                |                                    |
|          └          |             div              |       Internal 🔒        |                |                                    |
|          └          |             mod              |       Internal 🔒        |                |                                    |
|          └          |             sub              |       Internal 🔒        |                |                                    |
|          └          |             div              |       Internal 🔒        |                |                                    |
|          └          |             mod              |       Internal 🔒        |                |                                    |
|                     |                              |                          |                |                                    |
|     **IERC20**      |          Interface           |                          |                |                                    |
|          └          |         totalSupply          |       External ❗️       |                |               NO❗️                |
|          └          |          balanceOf           |       External ❗️       |                |               NO❗️                |
|          └          |           transfer           |       External ❗️       |       🛑       |               NO❗️                |
|          └          |          allowance           |       External ❗️       |                |               NO❗️                |
|          └          |           approve            |       External ❗️       |       🛑       |               NO❗️                |
|          └          |         transferFrom         |       External ❗️       |       🛑       |               NO❗️                |
|                     |                              |                          |                |                                    |
| **ReentrancyGuard** |        Implementation        |                          |                |                                    |
|          └          |        <Constructor>         |        Public ❗️        |       🛑       |               NO❗️                |

Legend

| Symbol | Meaning                   |
| :----: | ------------------------- |
|   🛑   | Function can modify state |
|   💵   | Function is payable       |
