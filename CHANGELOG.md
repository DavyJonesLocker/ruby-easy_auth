### EasyAuth 0.3.0

* Reverted array identities
* Updated Rails to ~> 4.0.0
* Identities are destroy dependent of parent
* Identities are always autosave
* Identities will require validation for parent to save
* Identities require presence of token
* Accounts accept nested attributes for identities
* SessionsController#create will rescue DoubleRenderErrors
