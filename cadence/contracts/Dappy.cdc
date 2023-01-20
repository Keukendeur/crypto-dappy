import NonFungibleToken from "./NonFungibleToken.cdc"
<<<<<<< HEAD
=======
import MetadataViews from "./MetadataViews.cdc"
>>>>>>> buildFix

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

<<<<<<< HEAD
    pub resource NFT: NonFungibleToken.INFT {
=======
    pub resource NFT: NonFungibleToken.INFT, MetadataViews.Resolver {
>>>>>>> buildFix

        pub let id: UInt64

        pub let metadata: {String: String}

<<<<<<< HEAD
=======
        // Proxy for MetadataViews.Resolver.getViews implemented by Template
        pub fun getViews(): [Type] {
            return [
                Type<MetadataViews.NFTView>(),
                Type<MetadataViews.Display>(),
                Type<MetadataViews.Royalties>(),
                Type<MetadataViews.ExternalURL>(),
                Type<MetadataViews.NFTCollectionDisplay>(),
                Type<MetadataViews.NFTCollectionData>()
            ]
        }

        pub fun resolveView(_ view: Type): AnyStruct? {
      switch view {
        case Type<MetadataViews.NFTView>():
          let viewResolver = &self as &{MetadataViews.Resolver}
          return MetadataViews.NFTView(
              id : self.id,
              uuid: self.uuid,
              display: MetadataViews.getDisplay(viewResolver),
              externalURL : MetadataViews.getExternalURL(viewResolver),
              collectionData : MetadataViews.getNFTCollectionData(viewResolver),
              collectionDisplay : MetadataViews.getNFTCollectionDisplay(viewResolver),
              royalties : MetadataViews.getRoyalties(viewResolver),
              traits : MetadataViews.getTraits(viewResolver)
          )
        case Type<MetadataViews.Display>():
          return MetadataViews.Display(
            name: self.metadata["name"]!,
            description: self.metadata["description"]!,
            thumbnail:
                MetadataViews.IPFSFile(
                    cid: self.metadata["imageCID"]!, 
                    path: nil
                ),
            )
        case Type<MetadataViews.ExternalURL>():
          return MetadataViews.ExternalURL("https://demo.cryptodappy.com/")
        case Type<MetadataViews.NFTCollectionData>():
          return MetadataViews.NFTCollectionData(
            storagePath: Dappy.CollectionStoragePath,
            publicPath: Dappy.CollectionPublicPath,
            providerPath: Dappy.CollectionPrivatePath,
            publicCollection: Type<@Dappy.Collection>(),
            publicLinkedType: Type<&Dappy.Collection{NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, MetadataViews.ResolverCollection}>(),
            providerLinkedType: Type<&Dappy.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection}>(),
            createEmptyCollectionFunction: fun(): @NonFungibleToken.Collection{
              return <- Dappy.createEmptyCollection()
            }
          )
        case Type<MetadataViews.NFTCollectionDisplay>():
            let squareMedia = MetadataViews.Media(
                file: MetadataViews.HTTPFile(
                    url: "https://demo.cryptodappy.com/assets/DappyPink.png"
                ),
                mediaType: "image"
            )
            let bannerMedia = MetadataViews.Media(
                file: MetadataViews.HTTPFile(
                    url: "https://demo.cryptodappy.com/assets/DappyPink.png"
                ),
                mediaType: "image"
            )
          return MetadataViews.NFTCollectionDisplay(
            name: "Crypto Dappy",
            description: "The brand new collectible game on the blockchain.",
            externalURL: MetadataViews.ExternalURL("https://demo.cryptodappy.com/"),
            squareImage: squareMedia,
            bannerImage: bannerMedia,
            socials: {}
          )
      }
      return nil
    }

>>>>>>> buildFix
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

<<<<<<< HEAD
    pub resource Collection: DappyCollectionPublic, NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {
=======
    pub resource Collection: DappyCollectionPublic, NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection {
>>>>>>> buildFix
        
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

<<<<<<< HEAD
=======
        pub fun borrowViewResolver(id: UInt64): &{MetadataViews.Resolver}{
            pre {
                self.ownedNFTs.containsKey(id)
                : "NFT does not exist in collection."
            }
            let nft = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
            let dappyNFT = nft as! &NFT
            return dappyNFT
        }

>>>>>>> buildFix
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
 