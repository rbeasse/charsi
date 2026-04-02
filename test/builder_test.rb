require_relative 'test_helper'
require_relative 'support/fixture_helper'

class BuilderTest < Minitest::Test
  include FixtureHelper

  def test_simple_build_outputs_html
    build_from_fixture('simple') do
      Charsi::Builder.new.build

      assert File.exist?('_build/index.html')
      assert File.exist?('_build/assets/javascript/app.js')
      assert File.exist?('_build/assets/css/app.css')

      html = File.read('_build/index.html')
      assert_includes html, '<title>Simple</title>'
      assert_includes html, '<h1>Hello</h1>'
    end
  end

  def test_non_html_erb_renders_without_layout
    build_from_fixture('simple') do
      Charsi::Builder.new.build

      assert File.exist?('_build/feed.xml')

      xml = File.read('_build/feed.xml')
      assert_includes xml, '<title>Simple Feed</title>'
      refute_includes xml, '<!DOCTYPE html>'
    end
  end

  def test_vendor_build_downloads_and_copies_vendor_js
    build_from_fixture('with_vendor') do
      downloaded_urls = stub_downloads { Charsi::Builder.new.build }

      assert File.exist?('_build/assets/vendor/stimulus.js')
      assert_includes downloaded_urls, 'https://unpkg.com/@hotwired/stimulus/dist/stimulus.js'
    end
  end
end
