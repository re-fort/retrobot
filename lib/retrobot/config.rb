require 'active_support'
require 'active_support/core_ext'
require 'psych'

class Retrobot
  class Config
    KEYS = %i(
      tweets_csv
      consumer_key
      consumer_secret
      access_token
      access_secret
      retro_days
      retweet
      debug
      dryrun
      loop_interval
      retry_interval
      retry_count
      add_in_reply_to_url
      suppress_pattern
      remove_hashtag
      dying_mention_to
    )

    DEFAULTS = {
      consumer_key: ENV['CONSUMER_KEY'],
      consumer_secret: ENV['CONSUMER_SECRET'],
      access_token: ENV['ACCESS_TOKEN'],
      access_secret: ENV['ACCESS_SECRET'],
      retro_days: ENV['RETRO_DAYS'],
      dying_mention_to: ENV['DYING_MENTION_TO'],
      tweets_csv: './tweets/tweets.csv',
      retweet: false,
      debug: false,
      dryrun: false,
      loop_interval: 3,
      retry_interval: 3,
      retry_count: 5,
      add_in_reply_to_url: false,
      suppress_pattern: nil,
      remove_hashtag: true,
    }

    def initialize(options={})
      @options = DEFAULTS.merge(options.symbolize_keys)
    end

    def merge!(hash)
      @options.merge!(hash)
    end

    KEYS.each do |k|
      define_method(k) { @options[k] }
    end

    def retro_days
      @options[:retro_days].to_i.days
    end

    def tweets_csv
      Pathname.new(@options[:tweets_csv])
    end

    def loop_interval;  @options[:loop_interval].to_i; end
    def retry_interval; @options[:retry_interval].to_i; end
    def retry_count;    @options[:retry_count].to_i; end

    def dying_mention_to
      return nil unless @options[:dying_mention_to]
      # add mention mark (atmark)
      @options[:dying_mention_to].start_with?('@') ?
        @options[:dying_mention_to] : "@" + @options[:dying_mention_to]
    end
  end
end
