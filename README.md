# Radiant Images

IMAGE management tool, meant only to be useful to pages and extensions that need to require images.

## Primary (only) Goals

### Light Weight

> We're not replacing paperclipped, we're just building a simple image manager extension.

### Uncomplicated

> People need to be able to look at the model and instantly know what it's doing, meaning they can easily extend it

### Easily Extendable

> Images is a base for things like galleries and shop, where they don't need additional asset types

### Strictly aws and paperclip

> We don't work with images locally because we use Heroku. So we're not going to give you the option to start locally

### Migrate from paperclipped easily

> paperclipped is freakin' awesome, we use it and we need to be able to migrate the images over

    rake radiant:extensions:images:migrate_from_paperclipped
    
### Flash uploads

> It's a messy business using the flash, but gives us the ability to poll to the server and upload multiple files