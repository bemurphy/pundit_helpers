require "pundit"
require "pundit_helpers"

class Harness
  def initialize
    @helper_methods = []
  end

  def current_user
    :spec_current_user
  end

  def self.helper_methods
    @helper_methods ||= []
  end

  def self.helper_method(name)
    self.helper_methods << name
  end

  include PunditHelpers
end

describe PunditHelpers, "#authorized?" do
  it "is true if #authorize returns true" do
    harness = Harness.new
    record = double
    expect(harness).to receive(:authorize).with(record, :show?).and_return(true)
    expect(harness.authorized?(record, :show?)).to be_true
  end

  it "is false if #authorize raises Pundit::NotAuthorizedError" do
    harness = Harness.new
    record = double
    expect(harness).to receive(:authorize).with(record, :show?).and_raise(Pundit::NotAuthorizedError)
    expect(harness.authorized?(record, :show?)).to be_false
  end

  it "is installed as a helper_method on module inclusion" do
    expect(Harness.helper_methods).to include(:authorized?)
  end
end

describe PunditHelpers, "#can?" do
  it "is true if the located policy permits the action" do
    record  = double
    policy  = double(:edit? => true)
    harness = Harness.new

    expect(Pundit).to receive(:policy!).with(:spec_current_user, record).and_return(policy)
    expect(harness.can?(:edit, record)).to be_true
  end

  it "is false if the located policy denies the action" do
    record  = double
    policy  = double(:edit? => false)
    harness = Harness.new

    expect(Pundit).to receive(:policy!).with(:spec_current_user, record).and_return(policy)
    expect(harness.can?(:edit, record)).to be_false
  end

  it "is installed as a helper_method on module inclusion" do
    expect(Harness.helper_methods).to include(:can?)
  end
end
