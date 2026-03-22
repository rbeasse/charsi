module FixtureHelper
  FIXTURES_PATH = File.join(__dir__, '../fixtures')

  def stub_downloads
    downloaded_urls = []

    fake_download = ->(url, destination) {
      downloaded_urls << url
      Charsi::FileManagement.write(destination, "// stub: #{url}")
    }

    Charsi::FileManagement.stub(:download, fake_download) { yield }

    downloaded_urls
  end

  def build_from_fixture(fixture_name, &block)
    fixture_path = File.join(FIXTURES_PATH, fixture_name)
    working_dir  = File.join(Dir.tmpdir, "charsi_build_test_#{fixture_name}")

    FileUtils.rm_rf(working_dir)
    FileUtils.cp_r(fixture_path, working_dir)

    Dir.chdir(working_dir, &block)
  ensure
    FileUtils.rm_rf(working_dir)
  end
end
