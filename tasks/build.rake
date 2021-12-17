# frozen_string_literal: true

require 'set'
require 'fileutils'

# PREFIX_DEST_PATH=/demo bundle exec rake build

desc 'Generates the code for every service'
task 'build' do
  if $PREFIX_DEST_PATH
    Dir.chdir($REAL_GEMS_DIR) do
      # There are a series of files we need to copy inorder for
      # the code generator to emit identical code that our
      # upstream generates.
      ["./**/VERSION", "./**/CHANGELOG.md", "./**/LICENSE.txt",
       "./**/customizations.rb", "./**/customizations/**",
       "./**/client_spec.rb", "./**/resource_spec.rb",
       "./**/client.feature",
       "./**/step_definitions.rb"].each do |pattern|
        Dir.glob(pattern).each do |src_file|
          next if File.directory? src_file
          dest_file = "#{$GEMS_DIR}/#{src_file}"
          FileUtils.mkdir_p(File.dirname dest_file)
          FileUtils.cp(src_file, dest_file, :verbose => true)
        end
      end
    end
  end
  BuildTools::Services.each do |service|
    Rake::Task["build:aws-sdk-#{service.identifier}"].invoke
  end
end

desc 'Generates the code for one service, e.g. `rake build  build:aws-sdk-dynamodb`'
task 'build:aws-sdk-*'

rule /^build:aws-sdk-\w+$/ do |task|
  identifier = task.name.split('-').last
  service = BuildTools::Services[identifier]
  files = AwsSdkCodeGenerator::GemBuilder.new(
    aws_sdk_core_lib_path: $CORE_LIB,
    service: service,
    client_examples: BuildTools.load_client_examples(service.identifier)
  )
  writer = BuildTools::FileWriter.new(directory: "#{$GEMS_DIR}/#{service.gem_name}")
  writer.write_files(files)
end

# Aws::STS is generated directly into the `aws-sdk-core` gem.
# It is need to provide session credentials and assume role support.
# Only building source, but not gemspecs, version file, etc.
task 'build:aws-sdk-sts' do
  sts = BuildTools::Services.service('sts')
  generator = AwsSdkCodeGenerator::CodeBuilder.new(
    aws_sdk_core_lib_path: $CORE_LIB,
    service: sts,
    client_examples: BuildTools.load_client_examples('sts'),
  )
  files = generator.source_files(prefix: 'aws-sdk-sts')
  writer = BuildTools::FileWriter.new(directory: "#{$GEMS_DIR}/aws-sdk-core/lib")
  writer.write_files(files)
end

# Aws::SSO is generated directly into the `aws-sdk-core` gem.
# It is need to provide SSO Credentials.
# Only building source, but not gemspecs, version file, etc.
task 'build:aws-sdk-sso' do
  sso = BuildTools::Services.service('sso')
  generator = AwsSdkCodeGenerator::CodeBuilder.new(
    aws_sdk_core_lib_path: $CORE_LIB,
    service: sso,
    client_examples: BuildTools.load_client_examples('sso'),
    )
  files = generator.source_files(prefix: 'aws-sdk-sso')
  writer = BuildTools::FileWriter.new(directory: "#{$GEMS_DIR}/aws-sdk-core/lib")
  writer.write_files(files)
end
