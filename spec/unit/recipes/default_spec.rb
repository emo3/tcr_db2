# Cookbook:: tcr_db2
# Spec:: default
#
# Copyright:: 2019, Ed Overton, Apache 2.0

require 'spec_helper'

describe 'tcr_db2::make_tcr' do
  context 'When all attributes are default, on an Redhat 7.x' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'redhat', version: '7')
      runner.converge(described_recipe)
    end
    before do
      stub_command('ps -ef | pgrep db2vend').and_return(true)
    end
    before do
      stub_command('db2 list database directory | grep TCRDB').and_return(true)
    end
    before do
      stub_command('db2 list database directory | grep REPORTER').and_return(true)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
