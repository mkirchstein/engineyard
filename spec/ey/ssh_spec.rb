require 'spec_helper'

describe "ey ssh" do
  it_should_behave_like "an integration test"

  before(:all) do
    api_scenario "one app, two environments"
  end

  it "SSH-es into the right environment" do
    print_my_args = "#!/bin/sh\necho ssh $*"

    ey "ssh giblets", :prepend_to_path => {'ssh' => print_my_args}
    @raw_ssh_commands.should == ["ssh turkey@174.129.198.124"]
  end

  it "complains if it has no app master" do
    ey "ssh bakon", :hide_err => true, :expect_failure => true
    @err.should =~ /'bakon' does not have a master instance/
  end

  it "complains if you give it a bogus environment" do
    print_my_args = "#!/bin/sh\necho ssh $*"

    ey "ssh bogusenv", :prepend_to_path => {'ssh' => print_my_args}, :hide_err => true
    @raw_ssh_commands.should be_empty
    @out.should =~ /could not find.*bogusenv/i
  end
end