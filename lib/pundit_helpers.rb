require "pundit_helpers/version"

module PunditHelpers
  # Pundit's core `#authorize` helper always raises
  # an error, but also lets the controller know an authorization
  # has been performed.  Sometimes it is preferrable to flag that an
  # authorization check has been made, but return boolean rather than
  # raise.  So this uses an exception rescue for flow control, which is
  # not optimal but fits nicely with the current API and doesn't cause
  # serious breakage

  def authorized?(record, query=nil)
    begin
      authorize(record, query)
    rescue Pundit::NotAuthorizedError
      false
    end
  end
end
