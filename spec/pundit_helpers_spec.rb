require "pundit"
require "pundit_helpers"

class Harness
  include PunditHelpers
end

describe PunditHelpers do
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
end
