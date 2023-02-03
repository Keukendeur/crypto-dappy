import "DappyContract"

pub fun main(): {UInt32: DappyContract.Template} {
  let templates = DappyContract.listTemplates()
  return templates
}

// flow scripts execute --network testnet Dappy/scripts/ListFamilyTemplates.cdc '1'