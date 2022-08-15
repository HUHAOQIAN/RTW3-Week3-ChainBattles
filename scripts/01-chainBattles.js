const { ethers, deployments } = require("hardhat")

async function main() {
    let getCharactersTx
    accounts = await ethers.getSigners()
    const deployer = accounts[0]
    const ChainBattles = await ethers.getContract("ChainBattles", deployer)
    // await ChainBattles.connect()
    const mintTx = await ChainBattles.mint()
    mintTxReceipt = await mintTx.wait()
    // console.log(mintTxReceipt)
    getCharactersTx = await ChainBattles.getCharacters("1")
    console.log(getCharactersTx.toString())
    const trainTx = await ChainBattles.train("2")
    await trainTx.wait()
    getCharactersTx = await ChainBattles.getCharacters("2")
    console.log(getCharactersTx.toString())
}

main()
