module Charsi
  # Tools for working with files.
  class FileManagement
    # Write a file ensuring that all folders in the path exist.
    #
    # Can optionally slugify the file for cache.
    def self.write(path, content, with_slug: false)
      destination_folder = File.dirname(path)

      FileUtils.mkdir_p(destination_folder)
      File.write(path, content)
    end

    # Copy a file ensuring that all folders in the path exist.
    def self.copy(path, destination)
      destination_folder = File.dirname(destination)

      FileUtils.mkdir_p(destination_folder)
      FileUtils.cp(path, destination)
    end

    def self.reset_output_dir
      FileUtils.rm_rf(OUTPUT_DIR) if Dir.exist?(OUTPUT_DIR)
      FileUtils.mkdir_p(OUTPUT_DIR)
    end
  end
end