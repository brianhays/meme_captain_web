# encoding: UTF-8

require 'spec_helper'

describe 'src_sets/new.html.erb' do

  it 'renders' do
    assign(:src_set, stub_model(SrcSet))
    render
  end

end
