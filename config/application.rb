require_relative "boot"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Studyring
  class Application < Rails::Application
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    # デフォルトのlocaleを日本語(:ja)にする
    config.i18n.default_locale = :ja

    # locales直下にファイルを置かずフォルダ分けする場合はパスを追加
    # config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}").to_s]
  end
end
