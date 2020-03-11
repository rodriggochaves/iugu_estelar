require 'json'

module IuguEstelar
  module TextDatabase
    def self.save(filename, content)
      file = File.open("tmp/#{filename}", "w")
      file.write(content)
    end

    def self.load(filename)
      file = File.open("tmp/#{filename}", "r")
      JSON.parse(file.read(content))
    end
  end
end
