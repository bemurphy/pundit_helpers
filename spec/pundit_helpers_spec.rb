require "pundit"
require "pundit_helpers"

class Harness
  def initialize
    @helper_methods = []
  end

  def pundit_user
    :spec_pundit_user
  end

  def self.helper_methods
    @helper_methods ||= []
  end

  def self.helper_method(name)
    self.helper_methods << name
  end

  include PunditHelpers
end

class Post
end

class PostPolicy < Struct.new(:user, :post)
  def edit?
    user == :mr_joe
  end

  def show?
    true
  end
end

describe PunditHelpers do
  let(:harness) { Harness.new }
  let(:record) { Post.new }

  before do
    allow(harness).to receive(:authorize).and_call_original
  end

  describe "#authorized?" do
    context "when authorization succeeds" do
      it "is true if #authorize returns true" do
        expect(harness.authorized?(record, :show?)).to eq true
        expect(harness).to have_received(:authorize).with(record, :show?)
      end
    end

    context "when authorization fails" do
      it "is false if #authorize raises Pundit::NotAuthorizedError" do
        expect(harness.authorized?(record, :edit?)).to be false
        expect(harness).to have_received(:authorize).with(record, :edit?)
      end
    end

    it "is installed as a helper_method on module inclusion" do
      expect(Harness.helper_methods).to include(:authorized?)
    end
  end

  describe "#can?" do
    let(:policy) { PostPolicy.new(:spec_pundit_user, record) }

    before do
      allow(Pundit).to receive(:policy!)
        .with(:spec_pundit_user, record)
        .and_return(policy)
    end

    it "is true if the located policy permits the action" do
      expect(harness.can?(:show, record)).to be true
      expect(Pundit).to have_received(:policy!).with(:spec_pundit_user, record)
    end

    it "is false if the located policy denies the action" do
      expect(harness.can?(:edit, record)).to be false
      expect(Pundit).to have_received(:policy!).with(:spec_pundit_user, record)
    end

    it "is installed as a helper_method on module inclusion" do
      expect(Harness.helper_methods).to include(:can?)
    end
  end
end