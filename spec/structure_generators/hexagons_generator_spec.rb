require 'spec_helper'

RSpec.describe StructureGenerators::HexagonsGenerator do
  it_behaves_like 'a structure generator'
  it_behaves_like 'a named generator', :hexagons
end
