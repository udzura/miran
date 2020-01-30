require "miran/version"
require "miran/prom_dataset"
require "miran/client"
require "miran/renderer"

module Miran
  class Cli
    def self.run(argv)
      params = argv.getopts("", "api", "width", "height", "duration", "step")
      query = argv.last

      cli = Client.new(query, params: params)
      data = PromDataset.new(cli.prom_data)
      Renderer.new(data, params: params).render
    end
  end
end
