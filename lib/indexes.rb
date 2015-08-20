require 'yaml'

class Indexes
  def self.all
    FileUtils.touch('./data/production/index/all.index')
    YAML.load(File.read('./data/production/index/all.index')) || []
  end
end
