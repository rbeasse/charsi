Gem::Specification.new do |spec|
  spec.name    = 'charsi'
  spec.version = '0.1.0'

  spec.authors = ['Ryan Beasse']
  spec.email   = ['me@ryanbeasse.com']

  spec.summary  = 'Simple static site generator.'
  spec.homepage = 'https://github.com/rbeasse/charsi'
  spec.license  = 'MIT'

  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end

  spec.executables << 'charsi'

  spec.add_dependency 'terser', '~> 1.2'
  spec.add_dependency 'tilt', '~> 2.6'
  spec.add_dependency 'tailwindcss-ruby', '~> 4.1'
end
