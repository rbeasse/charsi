module Charsi
  # Tools for working with file operations.
  class FileManagement
    def self.write(path, content)
      destination_folder = File.dirname(path)

      FileUtils.mkdir_p(destination_folder)
      File.write(path, content)
    end

    def self.copy(path, destination)
      destination_folder = File.dirname(destination)

      FileUtils.mkdir_p(destination_folder)
      FileUtils.cp(path, destination)
    end

    def self.reset_output_dir(output_dir)
      FileUtils.rm_rf(output_dir) if Dir.exist?(output_dir)
      FileUtils.mkdir_p(output_dir)
    end
  end
end
