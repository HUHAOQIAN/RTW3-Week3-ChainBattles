const { network } = require("hardhat")
const { developmentChains } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")
module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deployer } = await getNamedAccounts()
    const { deploy, log } = deployments

    const args = []
    const chainBattles = await deploy("ChainBattles", {
        from: deployer,
        log: true,
        args: args,
        waitConfirmations: network.config.blockConfirmation || 1,
    })
    // log(process.env.POLYGONSCAN_API_KEY)
    if (!developmentChains.includes(network.name) && process.env.POLYGONSCAN_API_KEY) {
        log("verifying mumbai...")
        await verify(chainBattles.address, args)
    }
}

module.exports.tags = ["chainBattles"]
