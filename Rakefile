# frozen_string_literal: true

# If defined, this path must begin with a '/'
$PREFIX_DEST_PATH = ENV.fetch("PREFIX_DEST_PATH", "")

$REPO_ROOT = File.dirname(__FILE__)
$REAL_GEMS_DIR = "#{$REPO_ROOT}/gems"
$GEMS_DIR = "#{$REPO_ROOT}#{$PREFIX_DEST_PATH}/gems"
$CORE_LIB = "#{$REPO_ROOT}/gems/aws-sdk-core/lib"

$:.unshift("#{$REPO_ROOT}/build_tools")
$:.unshift("#{$REPO_ROOT}/build_tools/aws-sdk-code-generator/lib")
$:.unshift("#{$REAL_GEMS_DIR}/aws-sdk-core/lib")
$:.unshift("#{$REAL_GEMS_DIR}/aws-partitions/lib")
$:.unshift("#{$REAL_GEMS_DIR}/aws-eventstream/lib")
$:.unshift("#{$REAL_GEMS_DIR}/aws-sigv4/lib")

require 'build_tools'
require 'aws-sdk-code-generator'
require 'aws-sdk-core'

Dir.glob("#{$REPO_ROOT}/tasks/**/*.rake").each do |task_file|
  load(task_file)
end
