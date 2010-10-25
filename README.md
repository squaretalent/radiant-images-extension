# Radiant Images

Radiant Images is an IMAGE management tool, meant only to be useful to pages and extensions that need to require images.

## Primary (only) Goals

### Light Weight

> We're not replacing paperclipped, we're just building a simple image manager extension.

### Uncomplicated

> People need to be able to look at the model and instantly know what it's doing, being able to do so means they can easily extend it

### Flexible

> Images works with the local filesystem or S3 cloud storage.

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

The URL and path values will need to be altered from their default values to work correctly with S3 storage, see the section below for further information.

## URL and Path Settings

The URL and Path settings for images out of the box will work fine for local storage. If you want to customize the location of your stored files or the URL that is given to the user you will need to modify these settings.

These two fields contain symbols that will be interpolated into their actual values, for example :basename will be converted to the base file name (without the extension) of your uploaded image. 

You can find a list of symbols at http://github.com/thoughtbot/paperclip/wiki/interpolations. There are more symbols which you may be able to find by searching online also.

Here are some base values and their explanation of use:

#### Local file storage

produces a URL such as: /images/original_file-icon.png

    images.path = :rails_root/public/:class/:basename-:style.:extension
    images.url  = /:class/:basename-:style.:extension

#### Amazon S3 storage

produces a URL such as: http://s3.amazonaws.com/bucketname/images/original_file-icon.png

    images.path = :class/:basename-:style.:extension
    images.url  = :s3_path_url

#### Amazon S3 with FQDN (Requires a CNAME pointing to s3.amazonaws.com)

produces a URL such as: http://bucket.name/images/original_file-icon.png

    images.path = :class/:basename-:style.:extension
    images.url  = :s3_alias_url

## License

Radiant Images is licensed under the MIT standard license. See LICENSE for further information.