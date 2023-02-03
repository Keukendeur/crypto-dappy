import "DappyContract"

pub fun main(addr: Address): {UInt64: DappyContract.Template} {
  let account = getAccount(addr)
  let ref = account.getCapability<&{DappyContract.CollectionPublic}>(DappyContract.CollectionPublicPath)
              .borrow() ?? panic("Cannot borrow reference")
  let dappies = ref.listDappies()
  return dappies
}

// flow scripts execute --network testnet Dappy/scripts/ListUserDappies.cdc '0x1b97c2d4f7e33f11'