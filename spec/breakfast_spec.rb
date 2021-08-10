require 'spec_helper'

describe Parcel do
  it 'has a version number' do
    expect(Parcel::VERSION).not_to be nil
  end
end
