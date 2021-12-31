# frozen_string_literal: true

require 'set'
require 'fileutils'

# DEST_SUFFIX=cr PREFIX_DEST_PATH=/demo bundle exec rake build

def rename_extension(src_dir, glob, dst_dir, src_ext = nil, dst_ext = nil, move_src = false)
  return if not File.directory? src_dir
  Dir.chdir(src_dir) do
    Dir.glob(glob).each do |src_file|
      next if File.directory? src_file
      dst_file = "#{dst_dir}/#{src_file}"
      if src_ext and File.extname(dst_file) == ".#{src_ext}"
        # We need to rename this file
        dst_file = "#{File.dirname(dst_file)}/#{File.basename(dst_file, src_ext)}#{dst_ext}"
      end
      if File.exist? dst_file
        puts "#{dst_file} exists - skipping"
        next
      end
      FileUtils.mkdir_p(File.dirname dst_file)
      if move_src
        FileUtils.mv(src_file, dst_file, :verbose => true)
      else
        FileUtils.cp(src_file, dst_file, :verbose => true)
      end
    end
  end
end

desc 'Generates the code for every service'
task 'build' do
  if $PREFIX_DEST_PATH
    # we'll need to rename any .cr files to .rb
    rename_extension($GEMS_DIR, "**/*.#{$DEST_SUFFIX}", $GEMS_DIR,
                     src_ext = $DEST_SUFFIX,
                     dst_ext = "rb",
                     move_src = true)
    # There are a series of files we need to copy inorder for
    # the code generator to emit identical code that our
    # upstream generates.
    ["./**/VERSION", "./**/CHANGELOG.md", "./**/LICENSE.txt",
     "./**/customizations.rb", "./**/customizations/**",
     "./**/client_spec.rb", "./**/resource_spec.rb",
     "./**/client.feature",
     "./**/step_definitions.rb"].each do |pattern|
       rename_extension($REAL_GEMS_DIR, pattern, $GEMS_DIR)
    end
  end

  BuildTools::Services.each do |service|
    Rake::Task["build:aws-sdk-#{service.identifier}"].invoke
  end

  if $PREFIX_DEST_PATH
    # we'll need to rename our .rb files to .cr
    rename_extension($GEMS_DIR, "**/*.rb", $GEMS_DIR,
                     src_ext = "rb",
                     dst_ext = $DEST_SUFFIX,
                     move_src = true)
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
