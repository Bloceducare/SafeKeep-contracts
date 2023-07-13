const fs = require("fs");
import { AbiCoder } from "@ethersproject/abi";
import { task } from "hardhat/config";

const vaultbasePath = "/contracts/Vault/facets/";
const vaultlibrarybasePath = "/contracts/Vault/libraries/";

task(
  "VaultdiamondABI",
  "Generates ABI file for vaultDiamond, includes all ABIs of facets"
).setAction(async () => {
  let vaultFiles = fs.readdirSync("." + vaultbasePath);
  let abi: AbiCoder[] = [];
  for (const file of vaultFiles) {
    const jsonFile = file.replace("sol", "json");
    let json = fs.readFileSync(
      `./artifacts/${vaultbasePath}${file}/${jsonFile}`
    );
    json = JSON.parse(json);
    abi.push(...json.abi);
  }
  vaultFiles = fs.readdirSync("." + vaultlibrarybasePath);
  for (const file of vaultFiles) {
    const jsonFile = file.replace("sol", "json");
    let json = fs.readFileSync(
      `./artifacts/${vaultlibrarybasePath}${file}/${jsonFile}`
    );
    json = JSON.parse(json);
    abi.push(...json.abi);
  }

  let finalAbi = JSON.stringify(abi);
  fs.writeFileSync("./diamondABI/vaultDiamond.json", finalAbi);
  console.log("ABI written to diamondABI/vaultdiamond.json");
});
