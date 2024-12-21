# frozen_string_literal: true

require_relative "dsk_rb/version"
require_relative "dsk_rb/client"

require 'faraday'
require 'active_support/core_ext/string/inflections'

module DskRb
  class Error < StandardError; end
end
