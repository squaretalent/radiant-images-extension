# Radiant Images

Radiant Images is an IMAGE management tool, meant only to be useful to pages and extensions that need to require images.

## Primary (only) Goals

### Light Weight

> We're not replacing paperclipped, we're just building a simple image manager extension.

### Uncomplicated

> People need to be able to look at the model and instantly know what it's doing, being able to do so means they can easily extend it

### Easily Extendable

> Images is a base for things like galleries and shop, where they don't need additional assets

### Migrate from paperclipped easily

> paperclipped is freakin' awesome, we use it and we need to be able to migrate the images over

    rake radiant:extensions:images:migrate_from_paperclipped

## Installation

The recommended way to install the radiant images extension is by installing the gem and configuring it in your radiant app, here are the instructions:

    gem install radiant-images-extension
    # add the following line to your config/environment.rb: config.gem 'radiant-images-extension', :lib => false
    rake radiant:extensions:images:update
    rake radiant:extensions:images:migrate

If you want to run a development copy of images simply clone a copy into radiant's vendor/extensions folder and then run a update/migrate on the extension.

## Contributors

Dirk Kelly, Mario Visic

## S3 Storage

By default images will use your local file storage. If you wish to use s3 to store your image, change the `images.storage` config key to `s3`. Leave it set as `local` to use your local file system.

    Radiant::Config['images.storage'] = 's3'

## Host Alias Settings

If you've setup images to use S3, by default the following url will be used for images:

    http://s3.amazonaws.com/bucketname/images/name_of_image-style.(png|jpg|gif)

There is a radiant configuration option called `s3.host_alias`. By default it is blank, if you give it a value, the images extension will use the FQDN method to access your images. Setting your host alias to `domain.name.com` for example would produce a URL like this:

    http://domain.name.com/images/name_of_image-style.(png|jpg|gif) 

## License

Radiant Images is licensed under the MIT standard license. See LICENSE for further information.