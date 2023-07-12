const fs = require("fs");
import { AbiCoder } from "@ethersproject/abi";
import { task } from "hardhat/config";

const factorybasePath = "/contracts/VaultFactory/facets/";
const factorylibrarybasePath = "/contracts/VaultFactory/libraries/";
task(
  "factoryDiamondABI",
  "Generates ABI file for diamondFactory, includes all ABIs of facets"
).setAction(async () => {
  let factoryFiles = fs.readdirSync("." + factorybasePath);
  let abi: AbiCoder[] = [];
  for (const file of factoryFiles) {
    const jsonFile = file.replace("sol", "json");
    let json = fs.readFileSync(
      `./artifacts/${factorybasePath}${file}/${jsonFile}`
    );
    json = JSON.parse(json);
    abi.push(...json.abi);
  }
  factoryFiles = fs.readdirSync("." + factorylibrarybasePath);
  for (const file of factoryFiles) {
    const jsonFile = file.replace("sol", "json");
    let json = fs.readFileSync(
      `./artifacts/${factorylibrarybasePath}${file}/${jsonFile}`
    );
    json = JSON.parse(json);
    abi.push(...json.abi);
  }

  let finalAbi = JSON.stringify(abi);
  fs.writeFileSync("./diamondABI/Factorydiamond.json", finalAbi);
  console.log("ABI written to diamondABI/Factorydiamond.json");
});
