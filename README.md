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

    gem install radiant-images-extension
    
Add the following line to your config/environment.rb: 
`config.gem 'radiant-images-extension', :lib => false`
    
    rake radiant:extensions:images:update
    rake radiant:extensions:images:migrate

## S3 Storage

By default images will use your local file storage. If you wish to use s3 to store your image, change the `images.storage` config key to `s3`.

    Radiant::Config['images.storage'] = 's3'

The URL and path values will need to be altered from their default values to work correctly with S3 storage, see the section below for examples.

## URL and Path Settings

The URL and Path settings for images out of the box will work fine for local storage, if you are using S3 then checkout the examples below:

You can find a list of symbols that can be used in the URL/Path [at the paperclip wiki](http://github.com/thoughtbot/paperclip/wiki/interpolations). There are more symbols which you may be able to find by searching online also.

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

## Passenger and ImageMagick

They don't always play nicely, if you're having strange errors such as

    /tmp/stream20101025-12485-nx6sdr-0 is not recognized by the 'identify' command.
     
Then ensure that you have set the config to match the location of imagemagick on your machine

    images.image_magick_path = /usr/local/bin

## Contributors

Dirk Kelly, Mario Visic

## License

Radiant Images is licensed under the MIT standard license. See LICENSE for further information.