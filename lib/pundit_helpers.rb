require "pundit_helpers/version"

module PunditHelpers
  def self.included(base)
    methods = [:authorized?, :can?]

    if base.respond_to?(:helper_method)
      methods.each { |m| base.helper_method(m) }
    end

    if respond_to?(:hide_action)
      methods.each { |m| base.hide_action(m) }
    end
  end

  # Pundit's core `#authorize` helper always raises
  # an error, but also lets the controller know an authorization
  # has been performed.  Sometimes it is preferrable to flag that an
  # authorization check has been made, but return boolean rather than
  # raise.  So this uses an exception rescue for flow control, which is
  # not optimal but fits nicely with the current API and doesn't cause
  # serious breakage
  #
  # @param [record] record - the record to check
  # @param [string or symbol] query - the policy action to check for
  #
  # @return [Boolean]
  def authorized?(record, query=nil)
    begin
      authorize(record, query)
    rescue Pundit::NotAuthorizedError
      false
    end
  end

  # The current user permissions can be policy checked in views:
  #
  # <% if can? :edit, @lesson %>
  #   <a href="/posts/42/edit">edit</a>
  # <% end %>
  #
  # @param [string or symbol] query - the query to check
  # @param [record] record - the record for policy lookup
  #
  # @return [Boolean]
  def can?(query, record)
    query  = "#{query}?"
    policy = Pundit.policy!(pundit_user, record)
    !! policy.public_send(query)
  end
end
