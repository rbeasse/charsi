module Charsi
  # The Generator class is responsible for creating new Charsi projects from our template.
  class Generator
    def self.generate(project, template: 'site')
      templates_dir  = File.join(__dir__, '../../templates', template)
      templates_glob = File.join(templates_dir, '**', '*.template')

      Dir.glob(templates_glob).each do |template|
        output_path = template.delete_prefix(templates_dir)
        output_path = output_path.delete_suffix('.template')
        output_path = File.join(Dir.pwd, project, output_path)
        
        processed_template = parse_erb(template, project)

        puts "[charsi] #{output_path}"

        Charsi::FileManagement.write(output_path, processed_template)
      end

      puts "\n[charsi] Created new static site: #{project}"
    end
    
    private
    
    def self.titleize(string)
      string.split(/_|-/).map(&:capitalize).join(' ')
    end

    def self.parse_erb(template_path, project)
      template = Tilt::ERBTemplate.new(template_path)
      
      template.render(nil, project_title: titleize(project))
    end
  end
end
