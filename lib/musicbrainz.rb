require 'digest/sha1'
require 'fileutils'
require 'faraday'
require 'roxml'
require File.expand_path('../vendor_extensions/roxml', File.dirname(__FILE__))
require 'rexml/document'

module MusicBrainz
  GH_PAGE_URL = 'http://git.io/brainz'

  autoload :Deprecated, File.expand_path('musicbrainz/deprecated', File.dirname(__FILE__))
  autoload :Middleware, File.expand_path('musicbrainz/middleware', File.dirname(__FILE__))
  autoload :Configuration, File.expand_path('musicbrainz/configuration', File.dirname(__FILE__))
  autoload :Client, File.expand_path('musicbrainz/client', File.dirname(__FILE__))
  
  autoload :BaseModel, File.expand_path('musicbrainz/models/base_model', File.dirname(__FILE__))
  
  # models
  autoload :Artist, File.expand_path('musicbrainz/models/artist', File.dirname(__FILE__))
  autoload :Release, File.expand_path('musicbrainz/models/release', File.dirname(__FILE__))
  autoload :ReleaseGroup, File.expand_path('musicbrainz/models/release_group', File.dirname(__FILE__))
  autoload :Recording, File.expand_path('musicbrainz/models/recording', File.dirname(__FILE__))
  autoload :Label, File.expand_path('musicbrainz/models/label', File.dirname(__FILE__))
  autoload :Work, File.expand_path('musicbrainz/models/work', File.dirname(__FILE__))
  autoload :Track, File.expand_path('musicbrainz/models/track', File.dirname(__FILE__))
  
  autoload :Url, File.expand_path('musicbrainz/models/url', File.dirname(__FILE__))
  autoload :Disc, File.expand_path('musicbrainz/models/disc', File.dirname(__FILE__))
  autoload :Puid, File.expand_path('musicbrainz/models/puid', File.dirname(__FILE__))
  autoload :Isrc, File.expand_path('musicbrainz/models/isrc', File.dirname(__FILE__))
  autoload :NameCredit, File.expand_path('musicbrainz/models/name_credit', File.dirname(__FILE__))
  autoload :Relation, File.expand_path('musicbrainz/models/relation', File.dirname(__FILE__))
  autoload :Alias, File.expand_path('musicbrainz/models/alias', File.dirname(__FILE__))
  autoload :Tag, File.expand_path('musicbrainz/models/tag', File.dirname(__FILE__))
  autoload :UserTag, File.expand_path('musicbrainz/models/user_tag', File.dirname(__FILE__))
  autoload :Rating, File.expand_path('musicbrainz/models/rating', File.dirname(__FILE__))
  autoload :LabelInfo, File.expand_path('musicbrainz/models/label_info', File.dirname(__FILE__))
  autoload :Medium, File.expand_path('musicbrainz/models/medium', File.dirname(__FILE__))
  autoload :Annotation, File.expand_path('musicbrainz/models/annotation', File.dirname(__FILE__))
  autoload :Cdstub, File.expand_path('musicbrainz/models/cdstub', File.dirname(__FILE__))
  autoload :FreedbDisc, File.expand_path('musicbrainz/models/freedb_disc', File.dirname(__FILE__))
  autoload :NonmbTrack, File.expand_path('musicbrainz/models/nonmb_track', File.dirname(__FILE__))
  autoload :Collection, File.expand_path('musicbrainz/models/collection', File.dirname(__FILE__))
  autoload :CoverArtArchive, File.expand_path('musicbrainz/models/cover_art_archive', File.dirname(__FILE__))
  
  module ClientModules
    autoload :TransparentProxy, File.expand_path('musicbrainz/client_modules/transparent_proxy', File.dirname(__FILE__))
    autoload :FailsafeProxy, File.expand_path('musicbrainz/client_modules/failsafe_proxy', File.dirname(__FILE__))
    autoload :CachingProxy, File.expand_path('musicbrainz/client_modules/caching_proxy', File.dirname(__FILE__))
  end

  module Mapper
    autoload :Entity, File.expand_path('musicbrainz/mapper/entity', File.dirname(__FILE__))
    autoload :List, File.expand_path('musicbrainz/mapper/list', File.dirname(__FILE__))
    autoload :SearchResult, File.expand_path('musicbrainz/mapper/search_result', File.dirname(__FILE__))
    
    module Generator
      autoload :Base, File.expand_path('musicbrainz/mapper/generator/base', File.dirname(__FILE__))
      autoload :Model, File.expand_path('musicbrainz/mapper/generator/model', File.dirname(__FILE__))
      autoload :Resource, File.expand_path('musicbrainz/mapper/generator/resource', File.dirname(__FILE__))
    end
    
    module Resources
      autoload :Artist, File.expand_path('musicbrainz/mapper/resources/artist', File.dirname(__FILE__))
      autoload :Release, File.expand_path('musicbrainz/mapper/resources/release', File.dirname(__FILE__))
      autoload :ReleaseGroup, File.expand_path('musicbrainz/mapper/resources/release_group', File.dirname(__FILE__))
      autoload :Recording, File.expand_path('musicbrainz/mapper/resources/recording', File.dirname(__FILE__))
      autoload :Label, File.expand_path('musicbrainz/mapper/resources/label', File.dirname(__FILE__))
      autoload :Work, File.expand_path('musicbrainz/mapper/resources/work', File.dirname(__FILE__))
      autoload :Track, File.expand_path('musicbrainz/mapper/resources/track', File.dirname(__FILE__))
      
      autoload :Url, File.expand_path('musicbrainz/mapper/resources/url', File.dirname(__FILE__))
      autoload :Disc, File.expand_path('musicbrainz/mapper/resources/disc', File.dirname(__FILE__))
      autoload :Puid, File.expand_path('musicbrainz/mapper/resources/puid', File.dirname(__FILE__))
      autoload :Isrc, File.expand_path('musicbrainz/mapper/resources/isrc', File.dirname(__FILE__))
      autoload :NameCredit, File.expand_path('musicbrainz/mapper/resources/name_credit', File.dirname(__FILE__))
      autoload :Relation, File.expand_path('musicbrainz/mapper/resources/relation', File.dirname(__FILE__))
      autoload :Alias, File.expand_path('musicbrainz/mapper/resources/alias', File.dirname(__FILE__))
      autoload :Tag, File.expand_path('musicbrainz/mapper/resources/tag', File.dirname(__FILE__))
      autoload :UserTag, File.expand_path('musicbrainz/mapper/resources/user_tag', File.dirname(__FILE__))
      autoload :Rating, File.expand_path('musicbrainz/mapper/resources/rating', File.dirname(__FILE__))
      autoload :LabelInfo, File.expand_path('musicbrainz/mapper/resources/label_info', File.dirname(__FILE__))
      autoload :Medium, File.expand_path('musicbrainz/mapper/resources/medium', File.dirname(__FILE__))
      autoload :Annotation, File.expand_path('musicbrainz/mapper/resources/annotation', File.dirname(__FILE__))
      autoload :Cdstub, File.expand_path('musicbrainz/mapper/resources/cdstub', File.dirname(__FILE__))
      autoload :FreedbDisc, File.expand_path('musicbrainz/mapper/resources/freedb_disc', File.dirname(__FILE__))
      autoload :NonmbTrack, File.expand_path('musicbrainz/mapper/resources/nonmb_track', File.dirname(__FILE__))
      autoload :Collection, File.expand_path('musicbrainz/mapper/resources/collection', File.dirname(__FILE__))
      autoload :CoverArtArchive, File.expand_path('musicbrainz/mapper/resources/cover_art_archive', File.dirname(__FILE__))  
    end
  end

  module Concerns
    autoload :ArtistName, File.expand_path('musicbrainz/models/concerns/artist_name', File.dirname(__FILE__))
  end
  
  module Configurable
    def configure
      raise Exception.new("Configuration block missing") unless block_given?
      yield @config ||= MusicBrainz::Configuration.new
      config.valid?
    end

    def config
      raise Exception.new("Configuration missing") unless instance_variable_defined?(:@config)
      @config
    end

    def apply_test_configuration!
      configure do |c|
        c.app_name = "gem musicbrainz (development mode)"
        c.app_version = MusicBrainz::VERSION
        c.contact = `git config user.email`.chomp
      end
    end
  end
  
  extend Configurable
  
  module ClientHelper
    def client
      @client ||= Client.new
    end
  end
  
  extend ClientHelper
end
