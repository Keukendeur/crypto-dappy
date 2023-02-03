import "DappyContract"

pub fun main(): [DappyContract.FamilyReport] {
  let families = DappyContract.listFamilies()
  return families
}

// flow scripts execute --network testnet Dappy/scripts/ListFamilies.cdc '0x1b97c2d4f7e33f11'