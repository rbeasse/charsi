require_relative 'test_helper'

class GeneratorTest < Minitest::Test
  GENERATED_PROJECT = File.join(Dir.tmpdir, 'charsi_test_project')

  def setup
    FileUtils.rm_rf(GENERATED_PROJECT)
    Dir.chdir(Dir.tmpdir) { Charsi::Generator.generate('charsi_test_project') }
  end

  def teardown
    FileUtils.rm_rf(GENERATED_PROJECT)
  end

  def test_generates_expected_files
    expected_files = [
      'Gemfile',
      'config.yml',
      'tailwind.config.js',
      '.devcontainer/devcontainer.json',
      'assets/css/tailwind.css',
      'assets/javascript/app.js',
      'layouts/default.erb',
      'views/index.erb'
    ]

    expected_files.each do |file|
      assert File.exist?(File.join(GENERATED_PROJECT, file)), "Expected #{file} to exist"
    end
  end

  def test_config_contains_project_paths
    config = YAML.safe_load_file(File.join(GENERATED_PROJECT, 'config.yml'))

    assert_equal '_build',   config.dig('paths', 'output_dir')
    assert_equal '.charsi',  config.dig('paths', 'cache_dir')
    assert_equal 'layouts',  config.dig('paths', 'layout_dir')
    assert_equal 'assets',   config.dig('paths', 'assets_dir')
    assert_equal 'views',    config.dig('paths', 'views_dir')
    assert_equal 'helpers',  config.dig('paths', 'helpers_dir')
  end

  def test_devcontainer_references_project_name
    devcontainer = JSON.parse(File.read(File.join(GENERATED_PROJECT, '.devcontainer/devcontainer.json')))

    assert_equal 'Charsi Test Project', devcontainer['name']
  end
end
