import NonFungibleToken from "./NonFungibleToken.cdc"

pub contract Dappy: NonFungibleToken {

    // Events
    //
    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)
    pub event Minted(id: UInt64)

    // Named Paths
    //
    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath
    pub let CollectionPrivatePath: PrivatePath
    pub let AdminStoragePath: StoragePath

    // totalSupply
    // The total number of Dappy that have been minted
    //
    pub var totalSupply: UInt64

    pub resource NFT: NonFungibleToken.INFT {

        pub let id: UInt64

        pub let metadata: {String: String}

        init(id: UInt64, metadata: {String: String}) {
            self.id = id
            self.metadata = metadata
        }
    }

    pub resource interface DappyCollectionPublic {
        pub fun deposit(token: @NonFungibleToken.NFT)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT
        pub fun borrowDappy(id: UInt64): &Dappy.NFT? {
            post {
                (result == nil) || (result?.id == id):
                    "Cannot borrow Dappy reference: The ID of the returned reference is incorrect"
            }
        }
    }

    pub resource Collection: DappyCollectionPublic, NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {
        
        // dictionary of NFTs
        // NFT is a resource type with an `UInt64` ID field
        //
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        // withdraw
        // Removes an NFT from the collection and moves it to the caller
        //
        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("missing NFT")

            emit Withdraw(id: token.id, from: self.owner?.address)

            return <- token
        }

        // deposit
        // Takes a NFT and adds it to the collections dictionary
        // and adds the ID to the id array
        //
        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @Dappy.NFT

            let id: UInt64 = token.id

            // add the new token to the dictionary which removes the old one
            let oldToken <- self.ownedNFTs[id] <- token

            emit Deposit(id: id, to: self.owner?.address)

            destroy oldToken
        }

        // getIDs
        // Returns an array of the IDs that are in the collection
        //
        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        // borrowNFT
        // Gets a reference to an NFT in the collection
        // so that the caller can read its metadata and call its methods
        //
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
        }

        // borrowDappy
        // Gets a reference to an NFT in the collection as a Dappy.
        //
        pub fun borrowDappy(id: UInt64): &Dappy.NFT? {
            if self.ownedNFTs[id] != nil {
                let ref = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
                return ref as! &Dappy.NFT
            } else {
                return nil
            }
        }

        // destructor
        destroy() {
            destroy self.ownedNFTs
        }

        // initializer
        //
        init () {
            self.ownedNFTs <- {}
        }
    }

    // createEmptyCollection
    // public function that anyone can call to create a new empty collection
    //
    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection()
    }

    // Admin
    // Resource that an admin can use to mint NFTs.
    //
    pub resource Admin {

        // mintNFT
        // Mints a new NFT with a new ID
        //
        pub fun mintNFT(metadata: {String: String}): @Dappy.NFT {
            let nft <- create Dappy.NFT(id: Dappy.totalSupply, metadata: metadata)

            emit Minted(id: nft.id)

            Dappy.totalSupply = Dappy.totalSupply +  1

            return <- nft
        }
    }

    // fetch
    // Get a reference to a Dappy from an account's Collection, if available.
    // If an account does not have a Dappy.Collection, panic.
    // If it has a collection but does not contain the itemID, return nil.
    // If it has a collection and that collection contains the itemID, return a reference to that.
    //
    pub fun fetch(_ from: Address, itemID: UInt64): &Dappy.NFT? {
        let collection = getAccount(from)
            .getCapability(Dappy.CollectionPublicPath)
            .borrow<&{ Dappy.DappyCollectionPublic }>()
            ?? panic("Couldn't get collection")

        // We trust Dappy.Collection.borowDappy to get the correct itemID
        // (it checks it before returning it).
        return collection.borrowDappy(id: itemID)
    }

    // initializer
    //
    init() {
        // Set our named paths
        self.CollectionStoragePath = /storage/DappyCollection
        self.CollectionPublicPath = /public/DappyCollection
        self.CollectionPrivatePath = /private/DappyCollection
        self.AdminStoragePath = /storage/DappyNFTAdmin

        // Initialize the total supply
        self.totalSupply = 0

        let collection <- Dappy.createEmptyCollection()
        
        self.account.save(<- collection, to: Dappy.CollectionStoragePath)

        self.account.link<&Dappy.Collection>(Dappy.CollectionPrivatePath, target: Dappy.CollectionStoragePath)

        self.account.link<&Dappy.Collection{NonFungibleToken.CollectionPublic, Dappy.DappyCollectionPublic}>(Dappy.CollectionPublicPath, target: Dappy.CollectionStoragePath)
        
        // Create an admin resource and save it to storage
        let admin <- create Admin()
        self.account.save(<- admin, to: self.AdminStoragePath)

        emit ContractInitialized()
    }
}
 