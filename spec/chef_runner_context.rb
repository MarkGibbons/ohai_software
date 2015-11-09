require 'rspec/core/shared_context'

# this is a 'standard' chef run, with no overrides
module ChefRun
  extend RSpec::Core::SharedContext

  let(:chef_run) do
    ChefSpec::ServerRunner.new.converge(described_recipe)
  end
end
