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
            url = "/c/" + SiteSetting.home_category_slug + "/" + SiteSetting.home_category_id + extension
            puts "redirect to: " + url
            redirect_to url
        end
    end

    class ::HomeCategoryConstraint
        def matches?(request)
            SiteSetting.home_category_id.present? && SiteSetting.home_category_slug.present?
        end
    end

    Discourse::Application.routes.prepend do
        get '/' => 'list#home_category', constraints: HomeCategoryConstraint.new
        get '/latest' => 'list#home_category', constraints: HomeCategoryConstraint.new
    end

    def get_home_category_slug
        category = Category.find_by(id: SiteSetting.home_category_id)
        category_slug = category ? category.slug : ''

        category_slug
    end

    on(:site_setting_changed) do |name, old_value, new_value|
        if name == :home_category_id
            category_slug = get_home_category_slug()
            SiteSetting.set(:home_category_slug, category_slug)
        elsif name == :home_category_slug
            category_slug = get_home_category_slug()
            if category_slug != new_value
                SiteSetting.set(:home_category_slug, category_slug)
            end
        end
    end

    if SiteSetting.home_category_id.present?
        category_slug = get_home_category_slug()
        SiteSetting.set(:home_category_slug, category_slug)
    end
end