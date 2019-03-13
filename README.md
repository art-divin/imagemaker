# Imagemaker
Simple app for fetching images from Flickr

# Idea
Project structure is distributed through modules.
Each module encapsulates whichever dependencies it has.
So that from the top level there's only a couple of APIs to use - a good example of DIP (SOLID).

# Modules

 - Combiner - module that combines
 - Container - module that contains (CoreData abstraction)
 - Locationer - module that locates (CoreLocation)
 - ImageProvider - module that provides images
