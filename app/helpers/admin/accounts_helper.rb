module Admin::AccountsHelper
  def js_for_list_accounts
    script = <<-eos
      jQuery('.delete').hide();
    eos
    javascript_tag(script)
  end
end
