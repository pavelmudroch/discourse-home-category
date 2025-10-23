# frozen_string_literal: true

# name: discourse-home-category
# about: Simple plugin to redirect home page to a category
# version: 0.1.0
# authors: Pavel Mudroch
# url: https://github.com/pavelmudroch/discourse-home-category

enabled_site_setting :home_category_enabled

after_initialize do
    class ::ListController
        def home_category
            extension = params[:format].present? ? "." + params[:format].to_s : ""
            url = "/c/" + SiteSetting.home_category_id + extension
            puts "redirect to: " + url
            redirect_to url
        end
    end

    class ::HomeCategoryConstraint
        def matches?(request)
            SiteSetting.home_category_id.present?
        end
    end

    Discourse::Application.routes.prepend do
        get '/' => 'list#home_category', constraints: HomeCategoryConstraint.new
        get '/latest' => 'list#home_category', constraints: HomeCategoryConstraint.new
    end
end