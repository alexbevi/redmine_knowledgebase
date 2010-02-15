module KnowledgebaseHelper
  # Display a link if the user is logged in
  def link_to_if_logged_in(name, options = {}, html_options = nil, *parameters_for_method_reference)
    link_to(name, options, html_options, *parameters_for_method_reference) if User.current.logged?
  end
end
